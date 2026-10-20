import { QueryClient } from '@tanstack/react-query';

import type { AppErrorKind } from '@/application/app-error';
import { QueryError } from '@/application/query-error';

// 4xx responses and parse failures are deterministic: a retry cannot change the outcome (ADR 0013).
const DETERMINISTIC_KINDS: ReadonlySet<AppErrorKind> = new Set([
  'refused',
  'unauthorized',
  'invalid',
]);

export function shouldRetryQuery(failureCount: number, error: Error): boolean {
  if (error instanceof QueryError && DETERMINISTIC_KINDS.has(error.appError.kind)) return false;
  return failureCount < 2;
}

export function createQueryClient(): QueryClient {
  return new QueryClient({
    defaultOptions: {
      queries: { refetchOnWindowFocus: false, retry: shouldRetryQuery },
      mutations: { retry: false },
    },
  });
}
