import type { AppError, AppErrorKind } from './app-error';

export type ErrorKey = `errors.${AppErrorKind}`;

/**
 * Maps an `AppError` to its translation key (ADR 0015). Pure: the key is checked against `en.json` where it is
 * passed to `t`. A per-code key is not supported yet: the contract publishes no codes.
 */
export function errorKey(error: AppError): ErrorKey {
  return `errors.${error.kind}`;
}
