import type { EmailsPort } from '@/application/emails';
import { ok } from '@/domain/result';

export function createFakeEmails(overrides: Partial<EmailsPort> = {}): EmailsPort {
  return { list: () => Promise.resolve(ok([])), ...overrides };
}
