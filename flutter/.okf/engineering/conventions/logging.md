---
type: Convention
title: "Logging"
description: "Log levels and their use through the Logger port; error is reserved for unrecoverable faults in the data layer."
resource: lib/utils/logger.dart
tags: [convention, logging]
status: stable
---
# Logging

Idea from tmail-flutter `docs/adr/0069` ([Reference](../../references/tmail-flutter.md)). Levels are `LogLevel` in
[`logger.dart`](../../../lib/utils/logger.dart); wiring is in [Observability](../../architecture/cross-cutting/observability.md).

| Level | Use |
|---|---|
| critical | Unrecoverable, system-level (very rare); uncaught errors |
| error | Actionable failure someone must be alerted about |
| warning | Recoverable problem, degraded behaviour (retry, skipped item, timeout) |
| info | Normal lifecycle events |
| debug | Developer detail (request, status, duration) |
| trace | High-volume diagnostics |

* `error` only for infrastructure faults in `data/`; expected failures are `Result` values. Network failures are not logged as `error`.
* Overusing `error` floods monitoring tools.
* What must never be logged (PII, tokens, bodies): rules S4 and S7 of [ADR 0020](../../adr/0020-security-baseline.md).
* Log through the injected `Logger`, never `print` or a logging package.
