import type { AppErrorKind } from '@/application/app-error';
import { QueryError } from '@/application/query-error';

import { createQueryClient, shouldRetryQuery } from './query-client';

describe('shouldRetryQuery', () => {
  it.each<AppErrorKind>(['refused', 'unauthorized', 'invalid'])('never retries %s', (kind) => {
    expect(shouldRetryQuery(0, new QueryError({ kind }))).toBe(false);
  });

  it('retries network errors twice', () => {
    const error = new QueryError({ kind: 'network' });

    expect(shouldRetryQuery(0, error)).toBe(true);
    expect(shouldRetryQuery(1, error)).toBe(true);
    expect(shouldRetryQuery(2, error)).toBe(false);
  });

  it('retries an unexpected error while the count is below 2', () => {
    expect(shouldRetryQuery(1, new Error('boom'))).toBe(true);
    expect(shouldRetryQuery(2, new Error('boom'))).toBe(false);
  });
});

describe('createQueryClient', () => {
  it('sets the ADR 0013 defaults', () => {
    const options = createQueryClient().getDefaultOptions();

    expect(options.queries?.refetchOnWindowFocus).toBe(false);
    expect(options.queries?.retry).toBe(shouldRetryQuery);
    expect(options.mutations?.retry).toBe(false);
  });
});
