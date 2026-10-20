import { screen } from '@testing-library/react';
import { HttpResponse, http } from 'msw';
import { setupServer } from 'msw/node';

import { createEmailsApi } from '@/adapters/api/emails-api';
import { createHttpClient } from '@/adapters/api/http-client';
import { createCookieSession } from '@/adapters/auth/cookie-session';
import { renderApp } from '@/test/render-with-providers';

const server = setupServer();

beforeAll(() => {
  server.listen({ onUnhandledFrame: 'error' });
});
afterEach(() => {
  server.resetHandlers();
});
afterAll(() => {
  server.close();
});

describe('session expiry (ADR 0014)', () => {
  it('a 401 from the API sends the user to sign-in, with the real client and cookie session', async () => {
    vi.spyOn(console, 'error').mockImplementation(() => undefined);
    server.use(
      http.get('http://api.test/session', () => HttpResponse.json({ id: '1', displayName: 'Ada' })),
      http.get('http://api.test/emails', () => new HttpResponse(null, { status: 401 })),
    );
    const client = createHttpClient({
      baseUrl: 'http://api.test',
      onUnauthorized: () => {
        session.expire();
      },
    });
    const session = createCookieSession(client);

    const { router } = renderApp({
      services: { session, emails: createEmailsApi(client) },
      path: '/emails',
    });

    expect(await screen.findByRole('heading', { name: 'Sign in' })).toBeInTheDocument();
    expect(router.state.location.pathname).toBe('/sign-in');
    expect(session.getSnapshot()).toEqual({ user: null });
  });
});
