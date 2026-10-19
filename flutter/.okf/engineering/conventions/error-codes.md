---
type: Convention
title: "Error Codes"
description: "AppError codes are Feature.Reason; common ones in utils/common_errors, feature ones in domain/errors, each localized."
tags: [convention, errors]
status: stable
---
# Error Codes

* Code pattern `Feature.Reason`: `Common.Network`, `Emails.NotFound`. `AppError` has a `code` and `ErrorType`, never a message.
* Errors any feature can hit: [`CommonErrors`](../../../lib/utils/common_errors.dart) (`Network`, `Unauthorized`, `Conflict`, `Validation`, `Server`, `Unknown`).
* Feature errors: one `<Feature>Errors` class in `lib/domain/errors/` with an `all` list, e.g. [`EmailErrors`](../../../lib/domain/errors/email_errors.dart).
* `ErrorType`: `validation`, `notFound`, `conflict`, `failure`, `unauthorized`, `network` (the last two are urgent, [ADR 0004](../../adr/0004-urgent-failures-single-handler.md)).
* A new code needs an ARB entry per locale and an arm in `errorMessage` ([Localization](../../architecture/cross-cutting/localization.md)).
* Tests assert on `error.code`, not only on "it failed".
