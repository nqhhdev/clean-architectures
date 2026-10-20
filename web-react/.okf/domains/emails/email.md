---
type: Entity
title: "Email"
description: "A message in the list: id, subject, sender, preview, receivedAt (Date) and read; built only with createEmail."
resource: src/domain/email.ts
tags: [domain, emails, entity]
status: draft
---
# Email

All fields are readonly: `id`, `subject`, `sender`, `preview` (strings), `receivedAt` (`Date`), `read` (boolean).

`createEmail(props)` returns `Ok(email)` or `Err(EmailInvalid)` ([email-errors](email-errors.md)). The adapter mapper
converts the DTO's ISO `receivedAt` string to a `Date` before calling it.
