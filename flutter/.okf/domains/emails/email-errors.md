---
type: Domain Errors
title: "Email Errors"
description: "The errors of the Emails slice: InvalidId and NotFound; transport errors are CommonErrors."
resource: lib/domain/errors/email_errors.dart
tags: [errors, email]
status: stable
---
# Email Errors

| Code | Type | When |
|---|---|---|
| `Emails.InvalidId` | validation | `Email.create` with a blank id (the repository skips such list items) |
| `Emails.NotFound` | notFound | HTTP 404 for an id |

Every other failure of the slice is a [`CommonErrors`](../../../lib/utils/common_errors.dart) code, mapped in
[Error Handling](../../architecture/cross-cutting/error-handling.md). Messages: `errorEmailsInvalidId`, `errorEmailsNotFound` in the ARB files.
Convention: [Error Codes](../../engineering/conventions/error-codes.md).
