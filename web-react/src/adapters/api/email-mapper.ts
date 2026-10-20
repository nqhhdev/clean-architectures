import type { z } from 'zod';

import type { AppError } from '@/application/app-error';
import { createEmail, type Email } from '@/domain/email';
import { err, ok, type Result } from '@/domain/result';

import type { ListEmailsResponseItem } from './generated/emails.zod';

export type EmailDto = z.output<typeof ListEmailsResponseItem>;

/** DTO to domain. A DTO the model rejects is a bad response: `invalid`, like a zod failure (ADR 0012). */
export function toEmail(dto: EmailDto): Result<Email, AppError> {
  const email = createEmail({ ...dto, receivedAt: new Date(dto.receivedAt) });
  return email.ok ? ok(email.value) : err({ kind: 'invalid', code: 'malformed_response' });
}

export function toEmails(dtos: EmailDto[]): Result<Email[], AppError> {
  const emails: Email[] = [];
  for (const dto of dtos) {
    const email = toEmail(dto);
    if (!email.ok) return email;
    emails.push(email.value);
  }
  return ok(emails);
}
