// @vitest-environment node
import { HttpResponse, http } from 'msw';
import { setupServer } from 'msw/node';

import { createHttpClient } from './http-client';
import { GetEmailResponse, ListEmailsResponse } from './generated/emails.zod';
import { getGetEmailMockHandler, getListEmailsMockHandler } from './generated/emails.msw';

const server = setupServer();
const client = createHttpClient({ baseUrl: 'http://api.test' });

beforeAll(() => {
  server.listen({ onUnhandledFrame: 'error' });
});
afterEach(() => {
  server.resetHandlers();
});
afterAll(() => {
  server.close();
});

const email = {
  id: 'e1',
  subject: 'Hello',
  sender: 'a@example.com',
  preview: 'Hi there',
  receivedAt: '2026-10-19T08:00:00Z',
  read: false,
};

describe('createHttpClient.get', () => {
  it('returns Ok with the parsed body', async () => {
    server.use(getListEmailsMockHandler([email]), getGetEmailMockHandler(email));

    expect(await client.get('/emails', ListEmailsResponse)).toEqual({ ok: true, value: [email] });
    expect(await client.get('/emails/e1', GetEmailResponse)).toEqual({ ok: true, value: email });
  });

  it('maps 401 to unauthorized', async () => {
    server.use(http.get('http://api.test/emails', () => new HttpResponse(null, { status: 401 })));

    expect(await client.get('/emails', ListEmailsResponse)).toEqual({
      ok: false,
      error: { kind: 'unauthorized', status: 401 },
    });
  });

  it('maps 403 to refused', async () => {
    server.use(http.get('http://api.test/emails', () => new HttpResponse(null, { status: 403 })));

    expect(await client.get('/emails', ListEmailsResponse)).toEqual({
      ok: false,
      error: { kind: 'refused', status: 403 },
    });
  });

  it('maps another 4xx to refused and keeps the API error code', async () => {
    server.use(
      http.get('http://api.test/emails/nope', () =>
        HttpResponse.json({ code: 'email_not_found' }, { status: 404 }),
      ),
    );

    expect(await client.get('/emails/nope', GetEmailResponse)).toEqual({
      ok: false,
      error: { kind: 'refused', status: 404, code: 'email_not_found' },
    });
  });

  it('maps 408 to network', async () => {
    server.use(http.get('http://api.test/emails', () => new HttpResponse(null, { status: 408 })));

    expect(await client.get('/emails', ListEmailsResponse)).toEqual({
      ok: false,
      error: { kind: 'network', status: 408 },
    });
  });

  it('maps 429 to network', async () => {
    server.use(http.get('http://api.test/emails', () => new HttpResponse(null, { status: 429 })));

    expect(await client.get('/emails', ListEmailsResponse)).toEqual({
      ok: false,
      error: { kind: 'network', status: 429 },
    });
  });

  it('maps 5xx to network', async () => {
    server.use(http.get('http://api.test/emails', () => new HttpResponse(null, { status: 503 })));

    expect(await client.get('/emails', ListEmailsResponse)).toEqual({
      ok: false,
      error: { kind: 'network', status: 503 },
    });
  });

  it('maps a failed request to network', async () => {
    server.use(http.get('http://api.test/emails', () => HttpResponse.error()));

    expect(await client.get('/emails', ListEmailsResponse)).toEqual({
      ok: false,
      error: { kind: 'network' },
    });
  });

  it('maps a body that fails the zod schema to invalid', async () => {
    server.use(getListEmailsMockHandler([{ ...email, read: 'yes' } as unknown as typeof email]));

    expect(await client.get('/emails', ListEmailsResponse)).toEqual({
      ok: false,
      error: { kind: 'invalid', status: 200, code: 'malformed_response' },
    });
  });

  it('maps a body that is not JSON to invalid', async () => {
    server.use(
      http.get('http://api.test/emails', () => new HttpResponse('<html>', { status: 200 })),
    );

    expect(await client.get('/emails', ListEmailsResponse)).toEqual({
      ok: false,
      error: { kind: 'invalid', status: 200, code: 'malformed_response' },
    });
  });
});

describe('createHttpClient session and security behaviour', () => {
  it('sends credentials on every request', async () => {
    const fetchSpy = vi.fn<typeof fetch>(() => Promise.resolve(Response.json([])));
    const spied = createHttpClient({ baseUrl: 'http://api.test', fetch: fetchSpy });

    await spied.get('/emails', ListEmailsResponse);

    expect(fetchSpy).toHaveBeenCalledWith(
      'http://api.test/emails',
      expect.objectContaining({ method: 'GET', credentials: 'include' }),
    );
  });

  it('adds the CSRF headers to non-GET requests only', async () => {
    const seen: Record<string, string | null> = {};
    server.use(
      http.get('http://api.test/emails', ({ request }) => {
        seen.get = request.headers.get('x-xsrf-token');
        return HttpResponse.json([]);
      }),
      http.delete('http://api.test/session', ({ request }) => {
        seen.delete = request.headers.get('x-xsrf-token');
        return new HttpResponse(null, { status: 204 });
      }),
    );
    const csrf = createHttpClient({
      baseUrl: 'http://api.test',
      csrfHeaders: () => ({ 'X-XSRF-TOKEN': 'csrf-value' }),
    });

    await csrf.get('/emails', ListEmailsResponse);
    expect(await csrf.delete('/session')).toEqual({ ok: true, value: undefined });

    expect(seen).toEqual({ get: null, delete: 'csrf-value' });
  });

  it('calls onUnauthorized once per 401 and for no other status', async () => {
    const onUnauthorized = vi.fn();
    const guarded = createHttpClient({ baseUrl: 'http://api.test', onUnauthorized });
    server.use(
      http.get('http://api.test/emails', () => new HttpResponse(null, { status: 401 })),
      http.get('http://api.test/emails/x', () => new HttpResponse(null, { status: 403 })),
    );

    await guarded.get('/emails', ListEmailsResponse);
    expect(onUnauthorized).toHaveBeenCalledTimes(1);

    await guarded.get('/emails/x', GetEmailResponse);
    expect(onUnauthorized).toHaveBeenCalledTimes(1);
  });

  it('maps a failed delete and reports 401 on it too', async () => {
    const onUnauthorized = vi.fn();
    const guarded = createHttpClient({ baseUrl: 'http://api.test', onUnauthorized });
    server.use(
      http.delete('http://api.test/session', () => new HttpResponse(null, { status: 401 })),
    );

    expect(await guarded.delete('/session')).toEqual({
      ok: false,
      error: { kind: 'unauthorized', status: 401 },
    });
    expect(onUnauthorized).toHaveBeenCalledTimes(1);
  });

  it('logs method, path, status and duration only, without the query string', async () => {
    const logger = { debug: vi.fn(), info: vi.fn(), warn: vi.fn(), error: vi.fn() };
    const logged = createHttpClient({
      baseUrl: 'http://api.test',
      csrfHeaders: () => ({ 'X-XSRF-TOKEN': 'csrf-value' }),
      logger,
    });
    server.use(http.get('http://api.test/emails', () => HttpResponse.json([])));

    await logged.get('/emails?q=ada@example.com', ListEmailsResponse);

    expect(logger.debug).toHaveBeenCalledWith('http', {
      method: 'GET',
      path: '/emails',
      status: 200,
      durationMs: expect.any(Number) as number,
    });
    expect(JSON.stringify(logger.debug.mock.calls)).not.toContain('csrf-value');
  });

  it('logs a failed request without a status', async () => {
    const logger = { debug: vi.fn(), info: vi.fn(), warn: vi.fn(), error: vi.fn() };
    const logged = createHttpClient({ baseUrl: 'http://api.test', logger });
    server.use(http.get('http://api.test/emails', () => HttpResponse.error()));

    await logged.get('/emails', ListEmailsResponse);

    expect(logger.debug).toHaveBeenCalledWith('http', {
      method: 'GET',
      path: '/emails',
      durationMs: expect.any(Number) as number,
    });
  });
});
