// Must stay the first import: schemas are built when their modules load (see the file).
import './app/zod-config';

import { setupWorker } from 'msw/browser';

import { createEmailsApi } from './adapters/api/emails-api';
import { getListEmailsMockHandler } from './adapters/api/generated/emails.msw';
import { createHttpClient } from './adapters/api/http-client';
import { createInMemorySession } from './adapters/auth/in-memory-session';
import { createConsoleLogger } from './adapters/telemetry/console-logger';
import { createLoggerCrashReporter } from './adapters/telemetry/logger-crash-reporter';
import { mountApp } from './app/bootstrap';

// Mock composition root (ADR 0010, 0017): same `Services` shape as `main.tsx` and the same API adapter, with MSW
// answering instead of the API and a signed-in demo user. The mode that selects this entry arrives in step 9.
const worker = setupWorker(
  getListEmailsMockHandler([
    {
      id: 'e1',
      subject: 'Welcome to web-react',
      sender: 'team@example.com',
      preview: 'This list is served by MSW in mock mode.',
      receivedAt: '2026-10-19T08:00:00Z',
      read: false,
    },
    {
      id: 'e2',
      subject: 'Your weekly summary',
      sender: 'reports@example.com',
      preview: 'Nothing happened this week.',
      receivedAt: '2026-10-18T17:30:00Z',
      read: true,
    },
  ]),
);
await worker.start({ onUnhandledFrame: 'error' });

const logger = createConsoleLogger();
mountApp({
  session: createInMemorySession({ id: 'demo', displayName: 'Demo user' }),
  emails: createEmailsApi(createHttpClient({ baseUrl: '/api' })),
  logger,
  crashReporter: createLoggerCrashReporter(logger),
});
