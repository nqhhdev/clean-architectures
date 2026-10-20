import type { Email } from '@/domain/email';
import type { Result } from '@/domain/result';

import type { AppError } from './app-error';

export interface EmailsPort {
  /** Newest first. Never throws for expected failures (ADR 0012). */
  list: (signal?: AbortSignal) => Promise<Result<Email[], AppError>>;
}
