import { z } from 'zod';

import { err, ok, type Result } from '@/domain/result';

/** Hosts that may use plain http: a developer machine, never a deployed environment (S2, ADR 0019). */
const LOCAL_HOSTS = new Set(['localhost', '127.0.0.1', '[::1]']);

function isLocalHost(hostname: string): boolean {
  return LOCAL_HOSTS.has(hostname) || hostname.endsWith('.localhost');
}

/**
 * The API base URL: a same-origin path (`/api`) or an absolute URL. Anything that is not local must be https, and the
 * URL carries no credentials, query or fragment, so the same value can be placed in the CSP `connect-src`.
 */
const apiUrlSchema = z.string().transform((value, ctx) => {
  if (value.startsWith('/') && !value.startsWith('//')) {
    const path = value.replace(/\/+$/, '');
    if (path === '') {
      ctx.addIssue({ code: 'custom', message: 'API_URL must name a path below "/"' });
      return z.NEVER;
    }
    return path;
  }
  let url: URL;
  try {
    url = new URL(value);
  } catch {
    ctx.addIssue({
      code: 'custom',
      message: 'API_URL must be an absolute URL or a path starting with "/"',
    });
    return z.NEVER;
  }
  if (url.protocol !== 'https:' && !(url.protocol === 'http:' && isLocalHost(url.hostname))) {
    ctx.addIssue({ code: 'custom', message: 'API_URL must use https unless the host is local' });
    return z.NEVER;
  }
  if (url.username || url.password || url.search || url.hash) {
    ctx.addIssue({
      code: 'custom',
      message: 'API_URL must not contain credentials, a query or a fragment',
    });
    return z.NEVER;
  }
  return value.replace(/\/+$/, '');
});

const runtimeConfigSchema = z.object({ API_URL: apiUrlSchema });

export interface RuntimeConfig {
  readonly apiUrl: string;
}

export interface RuntimeConfigOptions {
  /** Used when `/env.js` set nothing; only development passes it, so a deployed build cannot fall back. */
  readonly fallbackApiUrl?: string | undefined;
}

/**
 * Parses what `/env.js` put on `window.__ENV__`. The single place that validates runtime configuration: the caller
 * shows `error` and stops, so the app never starts half configured.
 */
export function parseRuntimeConfig(
  raw: unknown,
  { fallbackApiUrl }: RuntimeConfigOptions = {},
): Result<RuntimeConfig, string> {
  const source = typeof raw === 'object' && raw !== null ? raw : {};
  const candidate = { API_URL: 'API_URL' in source ? source.API_URL : fallbackApiUrl };
  const parsed = runtimeConfigSchema.safeParse(candidate);
  if (!parsed.success) {
    return err(parsed.error.issues.map((issue) => issue.message).join('; '));
  }
  return ok({ apiUrl: parsed.data.API_URL });
}

declare global {
  interface Window {
    __ENV__?: unknown;
  }
}

/** Reads `window.__ENV__` written by the `/env.js` script that `index.html` loads before the app module. */
export function readRuntimeConfig(
  target: Pick<Window, '__ENV__'>,
  options?: RuntimeConfigOptions,
): Result<RuntimeConfig, string> {
  return parseRuntimeConfig(target.__ENV__, options);
}
