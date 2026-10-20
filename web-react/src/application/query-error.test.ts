import type { AppError } from '@/application/app-error';
import { QueryError } from '@/application/query-error';

describe('QueryError', () => {
  it('carries the AppError and is an Error', () => {
    const appError: AppError = { kind: 'refused', status: 403, code: 'forbidden' };
    const error = new QueryError(appError);

    expect(error).toBeInstanceOf(Error);
    expect(error.name).toBe('QueryError');
    expect(error.message).toBe('Query failed: refused');
    expect(error.appError).toBe(appError);
  });
});
