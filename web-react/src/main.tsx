// Must stay the first import: schemas are built when their modules load (see the file).
import './app/zod-config';

import { createCsrfHeaders } from './adapters/api/csrf';
import { createEmailsApi } from './adapters/api/emails-api';
import { createHttpClient } from './adapters/api/http-client';
import { createCookieSession } from './adapters/auth/cookie-session';
import { createConsoleLogger } from './adapters/telemetry/console-logger';
import { createLoggerCrashReporter } from './adapters/telemetry/logger-crash-reporter';
import { renderBootError } from './app/boot-error';
import { mountApp } from './app/bootstrap';
import { readRuntimeConfig } from './app/runtime-config';

// Real composition root: builds the adapters. Boot has one failure path (ADR 0018): `/env.js` is parsed once and an
// invalid or missing config renders an error page and stops. Development falls back to `VITE_API_URL` or `/api`; a
// production build has no fallback. The HTTP client is the single 401 handler (ADR 0014): it ends the
// session through `onUnauthorized`, which reads `session` lazily because the session adapter itself needs the client.
const devApiUrl =
  typeof import.meta.env.VITE_API_URL === 'string' ? import.meta.env.VITE_API_URL : '/api';
const config = readRuntimeConfig(window, {
  fallbackApiUrl: import.meta.env.DEV ? devApiUrl : undefined,
});
if (config.ok) {
  const logger = createConsoleLogger();
  const http = createHttpClient({
    baseUrl: config.value.apiUrl,
    csrfHeaders: createCsrfHeaders(),
    onUnauthorized: () => {
      session.expire();
    },
    logger,
  });
  const session = createCookieSession(http);
  mountApp({
    session,
    emails: createEmailsApi(http),
    logger,
    crashReporter: createLoggerCrashReporter(logger),
  });
} else {
  renderBootError(document, config.error);
}
