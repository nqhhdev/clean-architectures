---
type: Mechanism
title: "Error Handling"
description: "How failures travel: ApiException in services, Result with AppError codes above, urgent routing and localized text in the UI."
tags: [errors, result]
status: stable
---
# Error Handling

| Where | Form | Code |
|---|---|---|
| `ApiClient` / service | throws `ApiException(ApiFailure.*)` with cause and stack | [`api_exception.dart`](../../../lib/data/services/api_exception.dart) |
| Repository | returns `Result<T>`; `appErrorFromApi` maps to `CommonErrors` or a feature error | [`api_error_mapper.dart`](../../../lib/data/repositories/api_error_mapper.dart) |
| ViewModel | asks `UrgentFailureHandler.handle`; else keeps the `AppError` in state | [Urgent Failure Handling](../../engineering/patterns/urgent-failure-handling.md) |
| View | banner, sign-in redirect, or `l10n.errorMessage(error)` with Retry | [Localization](localization.md) |
| Anything unexpected | `CrashReporter` (ViewModel guard, global hooks) | [Observability](observability.md) |

| `ApiFailure` | `AppError` |
|---|---|
| network | `Common.Network` (urgent) |
| unauthorized (401/403) | `Common.Unauthorized` (urgent) |
| notFound (404) | feature error, e.g. `Emails.NotFound` |
| conflict (409) / validation (400, 422) | `Common.Conflict` / `Common.Validation` |
| server (5xx) / malformed | `Common.Server` |

Urgent state is cleared only by real responses ([ADR 0019](../../adr/0019-urgent-failure-clearing-and-async-rules.md)).
Decisions: [ADR 0002](../../adr/0002-result-over-exceptions.md), [ADR 0018](../../adr/0018-data-layer-api-client-dtos-errors.md). Codes: [Error Codes](../../engineering/conventions/error-codes.md).
