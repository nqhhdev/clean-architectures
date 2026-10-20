// @vitest-environment node
import { HttpResponse, http } from 'msw';
import { setupServer } from 'msw/node';

import { toEmail } from './email-mapper';
import { createEmailsApi } from './emails-api';
import { getListEmailsMockHandler } from './generated/emails.msw';
import { createHttpClient } from './http-client';

const server = setupServer();
const api = createEmailsApi(createHttpClient({ baseUrl: 'http://api.test' }));

beforeAll(() => {
  server.listen({ onUnhandledFrame: 'error' });
});
afterEach(() => {
  server.resetHandlers();
});
afterAll(() => {
  server.close();
});

const dto = {
  id: 'e1',
  subject: 'Hello',
  sender: 'a@example.com',
  preview: 'Hi there',
  receivedAt: '2026-10-19T08:00:00Z',
  read: false,
};

describe('createEmailsApi', () => {
  it('maps the response to domain emails', async () => {
    server.use(getListEmailsMockHandler([dto]));

    const result = await api.list();

    expect(result).toEqual({
      ok: true,
      value: [{ ...dto, receivedAt: new Date('2026-10-19T08:00:00Z') }],
    });
  });

  it('returns an empty list for an empty response', async () => {
    server.use(getListEmailsMockHandler([]));

    expect(await api.list()).toEqual({ ok: true, value: [] });
  });

  it('maps a zod failure to invalid', async () => {
    server.use(http.get('*/emails', () => HttpResponse.json([{ id: 'e1' }])));

    expect(await api.list()).toEqual({
      ok: false,
      error: { kind: 'invalid', status: 200, code: 'malformed_response' },
    });
  });

  it('passes an HTTP failure through as an AppError', async () => {
    server.use(
      http.get('*/emails', () => HttpResponse.json({ code: 'forbidden' }, { status: 403 })),
    );

    expect(await api.list()).toEqual({
      ok: false,
      error: { kind: 'refused', status: 403, code: 'forbidden' },
    });
  });
});

describe('toEmail', () => {
  it('maps a DTO the model rejects to invalid', () => {
    expect(toEmail({ ...dto, id: '' })).toEqual({
      ok: false,
      error: { kind: 'invalid', code: 'malformed_response' },
    });
  });
});
