---
type: Component
title: "Domain layer"
description: "C4 level 3 - src/domain/: Result and the Email model; pure types and functions with no imports from other layers."
resource: src/domain
tags: [c4, components, domain, result]
status: draft
---
# Domain layer

`src/domain/` holds business types and pure functions. It imports no other layer and no framework (K1,
[ADR 0010](../../adr/0010-hexagonal-layers-boundaries-and-services.md)).

| File | Contents |
|---|---|
| `result.ts` | `Result<T, E>`, `ok()`, `err()` |
| `email.ts` | `Email`, `EmailInvalid`, `createEmail()` |

## Key types (C4 level 4)
```ts
type Result<T, E> = Ok<T> | Err<E>;   // Ok { ok: true, value }, Err { ok: false, error }
interface Email { id; subject; sender; preview; receivedAt: Date; read: boolean }   // all readonly
type EmailInvalid = 'empty_id' | 'invalid_date';
createEmail(props: Email): Result<Email, EmailInvalid>
```
* `Result` is generic in its error: the domain returns its own error types (`EmailInvalid`); `AppError` belongs to
  [application](application.md) ([ADR 0012](../../adr/0012-result-and-app-error.md)).
* `createEmail` is the one way to build an `Email` from untrusted input: it rejects a blank id and an unparseable date.

See [Emails domain](../../domains/emails/emails.md) and [Result](../../glossary/result.md).
