---
type: Component
title: "Config Layer"
description: "Dependency injection, configuration, logging and app-wide status: the one place that picks concrete implementations."
resource: lib/config
tags: [layer, config, di, riverpod]
status: stable
---
# Config Layer

| File | Holds |
|---|---|
| [`providers/core_providers.dart`](../../../lib/config/providers/core_providers.dart) | `appConfigProvider`, logger, crash reporter, HTTP client, `apiClientProvider`, urgent failure handler, auth token source |
| [`providers/email_providers.dart`](../../../lib/config/providers/email_providers.dart) | one `<feature>_providers.dart` per feature: service, repository, use cases |
| [`env.dart`](../../../lib/config/env.dart) | `AppConfig`, `AppEnvironment` - [Configuration](../cross-cutting/configuration.md) |
| [`logging.dart`](../../../lib/config/logging.dart), [`error_hooks.dart`](../../../lib/config/error_hooks.dart) | default `Logger` / `CrashReporter`, global hooks - [Observability](../cross-cutting/observability.md) |
| [`app_status.dart`](../../../lib/config/app_status.dart) | `AppStatus` notifier, `AppStatusFailureHandler` ([ADR 0019](../../adr/0019-urgent-failure-clearing-and-async-rules.md)) |

Allowed imports: [Layered Architecture](../cross-cutting/layered-architecture.md). Tests override these providers.
