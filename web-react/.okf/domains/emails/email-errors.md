---
type: Domain Errors
title: "Email errors"
description: "EmailInvalid (empty_id, invalid_date) from createEmail, and how the adapter maps it to an invalid AppError."
resource: src/domain/email.ts
tags: [domain, emails, errors]
status: draft
---
# Email errors

| Value | Cause |
|---|---|
| `empty_id` | `id` is empty or blank |
| `invalid_date` | `receivedAt` is not a valid date |

These are domain errors, not `AppError`s. `toEmail` in `adapters/api/email-mapper.ts` turns either into
`{ kind: 'invalid', code: 'malformed_response' }`, because a DTO the model rejects is a bad response. Network, 4xx and
5xx failures come from the HTTP client as `AppError` kinds ([Adapters layer](../../architecture/components/adapters.md)).
