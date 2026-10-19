---
type: ADR
title: "ADR 0012: Global error hooks behind Logger and CrashReporter ports"
description: "Every escaped error reaches one CrashReporter; logging and reporting are utils ports implemented in config."
tags: [adr, errors, logging, observability]
status: stable
---
# ADR 0012: Global error hooks behind Logger and CrashReporter ports

**Status:** Accepted - 2026-10-19. Replaces the "Wire a logger" backlog task.

## Context
Uncaught framework and async errors reached no reporter, release builds showed the framework error widget, and `data/` could not log
without importing a package into a restricted layer.

## Decision
* Ports in [`utils/logger.dart`](../../lib/utils/logger.dart): `Logger` (`LogLevel` trace..critical) and `CrashReporter`.
* Defaults in [`config/logging.dart`](../../lib/config/logging.dart): `ConsoleLogger` (`dart:developer`, warning+ in release)
  and `LoggingCrashReporter`; provided by `loggerProvider` / `crashReporterProvider` in [`core_providers.dart`](../../lib/config/providers/core_providers.dart).
* [`main.dart`](../../lib/main.dart) calls [`installErrorHooks`](../../lib/config/error_hooks.dart) (`FlutterError.onError` non-fatal,
  `PlatformDispatcher.onError` fatal) and sets `ErrorWidget.builder` to [`buildErrorWidget`](../../lib/ui/core/error_widget.dart).
* ViewModels report unexpected exceptions to the `CrashReporter` ([ADR 0019](0019-urgent-failure-clearing-and-async-rules.md)).

## Consequences
**Good.** No logging package in any layer; Sentry or Crashlytics replaces one provider. Tested in [`error_hooks_test.dart`](../../test/config/error_hooks_test.dart).
**Costly.** No crash backend ships; the release error widget is plain English because it may run outside `Localizations`.
**Alternatives rejected.** A logging package imported directly (breaks layer rules); `runZonedGuarded` (`PlatformDispatcher.onError` covers uncaught async errors).

## When to revisit
When a crash-reporting service is chosen.
