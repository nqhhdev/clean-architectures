import { screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

import { err, ok } from '@/domain/result';
import { createFakeCrashReporter } from '@/test/fakes/logger';
import { createFakeEmails } from '@/test/fakes/emails';
import { createFakeSession } from '@/test/fakes/session';
import { renderApp } from '@/test/render-with-providers';

const session = () => createFakeSession({}, { user: { id: '1', displayName: 'Ada' } });

const unread = {
  id: 'e1',
  subject: 'Hello',
  sender: 'a@example.com',
  preview: 'Hi there',
  receivedAt: new Date('2026-10-19T08:00:00Z'),
  read: false,
};
const read = { ...unread, id: 'e2', subject: 'Weekly', sender: 'b@example.com', read: true };

describe('EmailsScreen', () => {
  it('lists the emails and marks unread ones', async () => {
    const emails = createFakeEmails({ list: () => Promise.resolve(ok([unread, read])) });
    renderApp({ path: '/emails', services: { session: session(), emails } });

    expect(await screen.findByRole('heading', { name: 'Emails' })).toBeInTheDocument();
    expect(screen.getAllByRole('listitem')).toHaveLength(2);
    expect(screen.getByText('Hello (Unread)')).toBeInTheDocument();
    expect(screen.getByText('Weekly')).toBeInTheDocument();
  });

  it('shows the empty state', async () => {
    renderApp({ path: '/emails', services: { session: session() } });

    expect(await screen.findByText('No emails yet.')).toBeInTheDocument();
  });

  it('opens from the shell navigation', async () => {
    renderApp({ services: { session: session() } });

    await userEvent.click(await screen.findByRole('link', { name: 'Emails' }));

    expect(await screen.findByRole('heading', { name: 'Emails' })).toBeInTheDocument();
  });

  it('shows the localized message for the failure kind and reports it', async () => {
    const crashReporter = createFakeCrashReporter();
    const emails = createFakeEmails({
      list: () => Promise.resolve(err({ kind: 'network', status: 503 })),
    });
    renderApp({ path: '/emails', services: { session: session(), emails, crashReporter } });

    expect(
      await screen.findByText('The service is unreachable. Check your connection and try again.'),
    ).toBeInTheDocument();
    expect(screen.getByRole('alert')).toHaveTextContent('Something went wrong');
    expect(crashReporter.reported[0]?.context).toEqual({ source: 'route.errorComponent' });
  });
});
