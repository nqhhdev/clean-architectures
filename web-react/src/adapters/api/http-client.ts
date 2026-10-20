import { z } from 'zod';

import type { AppError } from '@/application/app-error';
import type { Logger } from '@/application/logger';
import { err, ok, type Result } from '@/domain/result';

// orval emits zod schemas for success responses only, so the error envelope of the contract (ApiError) is read here.
const errorBody = z.object({ code: z.string() });

export interface HttpClientOptions {
  baseUrl: string;
  fetch?: typeof fetch;
  /** Headers added to every non-GET request: the one CSRF hook (ADR 0009). */
  csrfHeaders?: () => Record<string, string>;
  /** Runs once per 401 response: the single place a session expiry is detected (ADR 0014). */
  onUnauthorized?: () => void;
  /** Receives method, path, status and duration of each call, never headers or bodies (S7). */
  logger?: Logger;
}

export interface HttpClient {
  /** Never throws for expected failures: maps them to `AppError` (ADR 0012). */
  get: <S extends z.ZodType>(
    path: string,
    schema: S,
    signal?: AbortSignal,
  ) => Promise<Result<z.output<S>, AppError>>;
  /** For calls whose success carries no body (sign-out). Sends the CSRF headers. */
  delete: (path: string, signal?: AbortSignal) => Promise<Result<undefined, AppError>>;
}

async function errorCode(response: Response): Promise<string | undefined> {
  try {
    const parsed = errorBody.safeParse(await response.json());
    return parsed.success ? parsed.data.code : undefined;
  } catch {
    return undefined;
  }
}

async function failure(response: Response): Promise<AppError> {
  const { status } = response;
  if (status === 401) return { kind: 'unauthorized', status };
  // 408 and 429 are transient: retry-friendly `network`, not `refused` (ADR 0012).
  if (status === 408 || status === 429) return { kind: 'network', status };
  if (status >= 400 && status < 500) {
    const code = await errorCode(response);
    return code === undefined ? { kind: 'refused', status } : { kind: 'refused', status, code };
  }
  return { kind: 'network', status };
}

const malformed = (status: number): AppError => ({
  kind: 'invalid',
  status,
  code: 'malformed_response',
});

export function createHttpClient({
  baseUrl,
  // Looked up per call, not captured, so a patched global fetch (MSW) is honoured.
  fetch: fetchImpl = (input, init) => fetch(input, init),
  csrfHeaders,
  onUnauthorized,
  logger,
}: HttpClientOptions): HttpClient {
  async function execute(
    method: 'GET' | 'DELETE',
    path: string,
    signal: AbortSignal | undefined,
  ): Promise<Result<Response, AppError>> {
    const started = performance.now();
    const log = (status?: number) => {
      // Path only: a query string can carry personal data (S7).
      logger?.debug('http', {
        method,
        path: path.split('?')[0],
        ...(status === undefined ? {} : { status }),
        durationMs: Math.round(performance.now() - started),
      });
    };

    let response: Response;
    try {
      response = await fetchImpl(baseUrl + path, {
        method,
        // The session is an httpOnly cookie the browser attaches; script never sees it (ADR 0009).
        credentials: 'include',
        ...(method !== 'GET' && csrfHeaders ? { headers: csrfHeaders() } : {}),
        ...(signal ? { signal } : {}),
      });
    } catch {
      log();
      return err({ kind: 'network' });
    }
    log(response.status);
    if (response.ok) return ok(response);

    const error = await failure(response);
    if (error.kind === 'unauthorized') onUnauthorized?.();
    return err(error);
  }

  return {
    async get(path, schema, signal) {
      const result = await execute('GET', path, signal);
      if (!result.ok) return result;

      const { value: response } = result;
      let body: unknown;
      try {
        body = await response.json();
      } catch {
        return err(malformed(response.status));
      }
      const parsed = schema.safeParse(body);
      return parsed.success ? ok(parsed.data) : err(malformed(response.status));
    },
    async delete(path, signal) {
      const result = await execute('DELETE', path, signal);
      return result.ok ? ok(undefined) : result;
    },
  };
}
