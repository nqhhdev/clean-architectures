import { QueryClient } from '@tanstack/react-query';

import { QueryError } from '@/application/query-error';
import { err, ok } from '@/domain/result';
import { createFakeEmails } from '@/test/fakes/emails';

import { emailKeys, emailsQueryOptions } from './queries';

const email = {
  id: 'e1',
  subject: 'Hello',
  sender: 'a@example.com',
  preview: 'Hi there',
  receivedAt: new Date('2026-10-19T08:00:00Z'),
  read: false,
};

describe('emailsQueryOptions', () => {
  it('uses the feature key constant', () => {
    expect(emailsQueryOptions({ emails: createFakeEmails() }).queryKey).toEqual(emailKeys.list());
  });

  it('returns the emails of an Ok result', async () => {
    const emails = createFakeEmails({ list: () => Promise.resolve(ok([email])) });

    const data = await new QueryClient().query(emailsQueryOptions({ emails }));

    expect(data).toEqual([email]);
  });

  it('throws a QueryError carrying the AppError of an Err result', async () => {
    const emails = createFakeEmails({
      list: () => Promise.resolve(err({ kind: 'network', status: 503 })),
    });

    const failure = new QueryClient().query(emailsQueryOptions({ emails }));

    await expect(failure).rejects.toBeInstanceOf(QueryError);
    await expect(failure).rejects.toMatchObject({ appError: { kind: 'network', status: 503 } });
  });
});
