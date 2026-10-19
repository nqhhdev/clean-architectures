---
type: Mechanism
title: "Observability"
description: "Logger and CrashReporter ports with console defaults; global hooks route every escaped error. No tracing or backend."
resource: lib/utils/logger.dart
tags: [logging, monitoring, crash-reporting]
status: stable
---
# Observability

| Piece | Where |
|---|---|
| Ports `Logger`, `CrashReporter`, `LogLevel` | [`utils/logger.dart`](../../../lib/utils/logger.dart) |
| `ConsoleLogger` (`dart:developer`, warning+ in release), `LoggingCrashReporter` | [`config/logging.dart`](../../../lib/config/logging.dart) |
| `FlutterError.onError` (non-fatal), `PlatformDispatcher.onError` (fatal) | [`config/error_hooks.dart`](../../../lib/config/error_hooks.dart), installed in [`main.dart`](../../../lib/main.dart) |
| Release error widget | [`ui/core/error_widget.dart`](../../../lib/ui/core/error_widget.dart) |
| Who logs | `ApiClient` (debug/warning per request), `EmailRepositoryRemote` (error, skipped items as warning), ViewModel guard (crash reporter) |

* Swap in a crash service by overriding `crashReporterProvider` in [`core_providers.dart`](../../../lib/config/providers/core_providers.dart).
* No tracing and no remote log sink exist.

Levels: [Logging](../../engineering/conventions/logging.md). Decision: [ADR 0012](../../adr/0012-global-error-hooks-logger-crash-reporter.md).
Tests: [`error_hooks_test.dart`](../../../test/config/error_hooks_test.dart).
