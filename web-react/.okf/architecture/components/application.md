---
type: Component
title: "Application layer"
description: "C4 level 3 - src/application/: ports (EmailsPort, SessionService, Logger, CrashReporter), the Services type, AppError and QueryError."
resource: src/application
tags: [c4, components, application, ports]
status: draft
---
# Application layer

`src/application/` declares what the app needs from the outside world as interfaces (ports) and defines the error
model. It imports `domain/` only and no framework (K1). [Adapters](adapters.md) implement the ports; features consume
them through `Services`.

| File | Contents |
|---|---|
| `emails.ts` | `EmailsPort` |
| `session.ts` | `SessionService`, `SessionSnapshot`, `SessionUser` |
| `logger.ts`, `crash-reporter.ts` | `Logger`, `CrashReporter` |
| `services.ts` | `Services`: the set of ports a composition root builds |
| `app-error.ts` | `AppError`, `AppErrorKind` |
| `query-error.ts` | `QueryError`: an `Error` that carries an `AppError` |
| `error-key.ts` | `errorKey(appError)`: the translation key for an error |

## Key types (C4 level 4)
```ts
interface Services { session: SessionService; emails: EmailsPort; logger: Logger; crashReporter: CrashReporter }

interface EmailsPort { list(signal?: AbortSignal): Promise<Result<Email[], AppError>> }

interface SessionService {
  getSnapshot(): SessionSnapshot;            // { user: SessionUser | null }
  subscribe(listener: () => void): () => void;
  bootstrap(): Promise<void>;
  signOut(): Promise<void>;
  expire(): void;                            // drops the user without a server call; idempotent
}

type AppErrorKind = 'refused' | 'unauthorized' | 'network' | 'invalid';
interface AppError { kind: AppErrorKind; status?: number; code?: string }
class QueryError extends Error { readonly appError: AppError }
errorKey(error: AppError): `errors.${AppErrorKind}`
```
* One port per resource, named for the resource (K8). A port does not throw for an expected failure; it returns
  `Err(AppError)` ([ADR 0012](../../adr/0012-result-and-app-error.md)).
* `SessionService` members are property signatures, not methods, because they are passed unbound to
  `useSyncExternalStore`.
* `QueryError` exists because TanStack Query needs a thrown error; only a feature's `queries.ts` creates it (K11).
* `errorKey` returns `errors.<kind>` only; the contract publishes no per-code keys yet.

See [AppError](../../glossary/app-error.md), [Port](../../glossary/port.md) and [Services](../../glossary/services.md).
