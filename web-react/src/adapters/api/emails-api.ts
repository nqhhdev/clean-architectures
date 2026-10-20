import type { EmailsPort } from '@/application/emails';

import { toEmails } from './email-mapper';
import { ListEmailsResponse } from './generated/emails.zod';
import type { HttpClient } from './http-client';

export function createEmailsApi(http: HttpClient): EmailsPort {
  return {
    async list(signal) {
      const result = await http.get('/emails', ListEmailsResponse, signal);
      return result.ok ? toEmails(result.value) : result;
    },
  };
}
