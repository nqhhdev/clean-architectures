import type { AppError } from './app-error';

export class QueryError extends Error {
  readonly appError: AppError;

  constructor(appError: AppError) {
    super(`Query failed: ${appError.kind}`);
    this.name = 'QueryError';
    this.appError = appError;
  }
}
