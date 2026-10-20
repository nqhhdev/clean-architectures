// @vitest-environment node
import { HttpResponse, http } from 'msw';
import { setupServer } from 'msw/node';

import { createHttpClient } from '@/adapters/api/http-client';

import { createCookieSession } from './cookie-session';
import { QueryError } from '@/application/query-error';

const server = setupServer();
const ada = { id: '1', displayName: 'Ada' };

beforeAll(() => {
  server.listen({ onUnhandledFrame: 'error' });
});
afterEach(() => {
  server.resetHandlers();
});
afterAll(() => {
  server.close();
});

/** The wiring of `main.tsx`: the client's 401 hook expires the session. */
function setup() {
  const client = createHttpClient({
    baseUrl: 'http://api.test',
    onUnauthorized: () => {
      session.expire();
    },
  });
  const session = createCookieSession(client);
  const listener = vi.fn();
  session.subscribe(listener);
  return { session, listener };
}

describe('createCookieSession', () => {
  it('starts signed out', () => {
    expect(setup().session.getSnapshot()).toEqual({ user: null });
  });

  it('bootstrap loads the user the API reports and notifies', async () => {
    server.use(http.get('http://api.test/session', () => HttpResponse.json(ada)));
    const { session, listener } = setup();

    await session.bootstrap();

    expect(session.getSnapshot()).toEqual({ user: ada });
    expect(listener).toHaveBeenCalledTimes(1);
  });

  it('bootstrap treats 401 as signed out without notifying or throwing', async () => {
    server.use(http.get('http://api.test/session', () => new HttpResponse(null, { status: 401 })));
    const { session, listener } = setup();

    await expect(session.bootstrap()).resolves.toBeUndefined();

    expect(session.getSnapshot()).toEqual({ user: null });
    expect(listener).not.toHaveBeenCalled();
  });

  it('bootstrap fails on an outage so a later navigation can retry', async () => {
    server.use(http.get('http://api.test/session', () => new HttpResponse(null, { status: 503 })));

    const failure = setup().session.bootstrap();
    await expect(failure).rejects.toBeInstanceOf(QueryError);
    await expect(failure).rejects.toMatchObject({ appError: { kind: 'network' } });
  });

  it('a 401 from any call expires the session once', async () => {
    server.use(http.get('http://api.test/session', () => HttpResponse.json(ada)));
    const { session, listener } = setup();
    await session.bootstrap();
    listener.mockClear();
    server.use(http.get('http://api.test/session', () => new HttpResponse(null, { status: 401 })));

    await session.bootstrap();
    await session.bootstrap();

    expect(session.getSnapshot()).toEqual({ user: null });
    expect(listener).toHaveBeenCalledTimes(1);
  });

  it('signOut calls the API, then drops the user', async () => {
    let called = false;
    server.use(
      http.get('http://api.test/session', () => HttpResponse.json(ada)),
      http.delete('http://api.test/session', () => {
        called = true;
        return new HttpResponse(null, { status: 204 });
      }),
    );
    const { session } = setup();
    await session.bootstrap();

    await session.signOut();

    expect(called).toBe(true);
    expect(session.getSnapshot()).toEqual({ user: null });
  });

  it('signOut keeps the user and throws when the API did not sign out', async () => {
    server.use(
      http.get('http://api.test/session', () => HttpResponse.json(ada)),
      http.delete('http://api.test/session', () => new HttpResponse(null, { status: 500 })),
    );
    const { session } = setup();
    await session.bootstrap();

    await expect(session.signOut()).rejects.toThrow('Sign-out failed: network');
    expect(session.getSnapshot()).toEqual({ user: ada });
  });

  it('signOut with an already expired session ends signed out', async () => {
    server.use(
      http.get('http://api.test/session', () => HttpResponse.json(ada)),
      http.delete('http://api.test/session', () => new HttpResponse(null, { status: 401 })),
    );
    const { session } = setup();
    await session.bootstrap();

    await expect(session.signOut()).resolves.toBeUndefined();
    expect(session.getSnapshot()).toEqual({ user: null });
  });

  it('stops notifying after unsubscribe', async () => {
    server.use(http.get('http://api.test/session', () => HttpResponse.json(ada)));
    const { session } = setup();
    const other = vi.fn();
    session.subscribe(other)();

    await session.bootstrap();

    expect(other).not.toHaveBeenCalled();
  });
});
