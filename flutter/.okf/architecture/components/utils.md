---
type: Component
title: "Utils Layer"
description: "Framework-free primitives every layer may use: Result, AppError, CommonErrors and the handler and logging ports."
resource: lib/utils
tags: [layer, utils, result]
status: stable
---
# Utils Layer

No dependencies on the rest of the app and no Flutter. Counterpart of the template's SharedKernel.

* [`Result<T>`](../../../lib/utils/result.dart) - `Success` / `Failure` ([ADR 0002](../../adr/0002-result-over-exceptions.md)).
* [`AppError`, `ErrorType`](../../../lib/utils/error.dart) and [`CommonErrors`](../../../lib/utils/common_errors.dart) ([Error Codes](../../engineering/conventions/error-codes.md)).
* [`UrgentFailureHandler`](../../../lib/utils/urgent_failure_handler.dart) - port ViewModels call ([ADR 0019](../../adr/0019-urgent-failure-clearing-and-async-rules.md)).
* [`Logger`, `CrashReporter`](../../../lib/utils/logger.dart) - ports implemented in `config/` ([ADR 0012](../../adr/0012-global-error-hooks-logger-crash-reporter.md)).
