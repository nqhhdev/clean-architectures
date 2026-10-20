---
type: Component
title: "Adapters layer"
description: "C4 level 3 - src/adapters/: the HTTP client, the Emails API adapter and mapper, session adapters, and the console logger and crash reporter."
resource: src/adapters
tags: [c4, components, adapters, http]
status: draft
---
# Adapters layer

`src/adapters/` is the only layer that performs I/O (K2): `fetch`, `document.cookie`, `console`. It implements the
ports of [application](application.md) and imports `application/` and `domain/` only. Only the composition roots and
adapter tests call an adapter factory (K3, K9).

| Folder | Contents |
|---|---|
| `api/http-client.ts` | `createHttpClient`: `get(path, schema)` and `delete(path)`, each returning `Result<_, AppError>` |
| `api/emails-api.ts`, `api/email-mapper.ts` | `createEmailsApi(http): EmailsPort`; DTO to `Email` mapping |
| `api/csrf.ts` | `createCsrfHeaders`: copies the `XSRF-TOKEN` cookie into the `X-XSRF-TOKEN` header |
| `api/generated/` | orval output (zod schemas, types, MSW handlers); git-ignored (K5) |
| `auth/cookie-session.ts` | `createCookieSession(http)`: `GET` and `DELETE /session`; keeps the user, never a token |
| `auth/in-memory-session.ts` | `createInMemorySession(user)`: signed-in demo session for mock mode |
| `telemetry/` | `createConsoleLogger`, `redact`, `createLoggerCrashReporter` |

## Key behaviour (C4 level 4)
`createHttpClient({ baseUrl, fetch?, csrfHeaders?, onUnauthorized?, logger? })` maps every outcome to an `AppError`:

| Outcome | `AppError` |
|---|---|
| 401 | `unauthorized`; `onUnauthorized` is called once ([ADR 0014](../../adr/0014-session-and-single-401-handler.md)) |
| 408, 429 | `network` (transient) |
| other 4xx | `refused`, with `code` read from the `{ code }` error body when present |
| 5xx, failed `fetch`, timeout | `network` |
| body not JSON, or zod failure | `invalid` with code `malformed_response` |

* Every request sends `credentials: 'include'`; non-GET requests get the CSRF headers from the one hook (K32).
* The logger receives method, path (without query string), status and duration only (K33).
* The mapper turns a DTO into an `Email` with `createEmail`; a DTO the model rejects is `invalid`, like a zod failure.
  The whole list fails on the first bad item.
* `createCookieSession().bootstrap()` treats a 401 as signed out and throws on any other failure; `signOut()` throws when
  the API did not sign the user out.

See [DTO](../../glossary/dto.md) and [Emails request flow](emails-sequence.md).
