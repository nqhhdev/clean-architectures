---
type: Domain Slice
title: "Emails"
description: "The example slice: a read-and-triage inbox that lists, marks read/unread and deletes emails."
tags: [domain, example]
status: stable
---
# Emails

Example slice (inspired by an email client's inbox, written from scratch). **Replace it with your own domain.**

| Operation | ViewModel | Use case | Repository | Endpoint |
|---|---|---|---|---|
| List (newest first) | `build()` / `refresh()` | `ListEmailsUseCase` | `getAll` | `GET /emails` |
| Mark read / unread | `toggleRead` | `ToggleEmailReadUseCase` | `setRead` | `PATCH /emails/{id}` |
| Delete | `delete` | `DeleteEmailUseCase` | `delete` | `DELETE /emails/{id}` |

Model: [Email](email.md). Errors: [Email Errors](email-errors.md).
Every layer's files: [Vertical Slice Architecture](../../architecture/cross-cutting/vertical-slice-architecture.md).
