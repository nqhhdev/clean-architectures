---
type: Domain Slice
title: "Emails"
description: "The sample slice: list emails newest first from GET /emails, across domain, port, adapter, query and screen."
tags: [domain, emails, slice]
status: draft
---
# Emails

The sample slice that gives the layer rules real code to check. Delete it when you start your own domain.

| Layer | Piece |
|---|---|
| Contract | `GET /emails` in `openapi/emails.yaml` (the contract also lists `GET /emails/{id}`; no port uses it yet) |
| Domain | [Email](email.md), [EmailInvalid](email-errors.md) |
| Application | `EmailsPort.list(signal?)` returns `Promise<Result<Email[], AppError>>` |
| Adapters | `createEmailsApi(http)` and `toEmails` in `adapters/api/` |
| Features | `emailsQueryOptions` and `emailKeys` in `features/emails/queries.ts`; `EmailsScreen` |
| App | `/emails` route under the shell, with a loader that prefetches the list |
| Strings | `emails.title`, `emails.empty`, `emails.unread` in `en.json` |

Behaviour: the list is shown in the order the API returns it (documented as newest first); an empty list shows
`emails.empty`; an unread email shows its subject followed by `(Unread)`. Failures reach the user as `errors.<kind>`.

Request path: [Emails request flow](../../architecture/components/emails-sequence.md).
