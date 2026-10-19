---
type: Reference
title: "Solution Layout"
description: "The directories and root files that make up the Flutter stack."
resource: pubspec.yaml
tags: [structure, repository]
status: stable
---
# Solution Layout

| Path | Holds | Concept |
|---|---|---|
| `lib/ui/` | Views, ViewModels, `core/` (routing, theme, l10n), `session/` | [UI Layer](../architecture/components/ui.md) |
| `lib/domain/` | Immutable models and errors; `use_cases/` | [Domain Layer](../architecture/components/domain.md), [Use Case Layer](../architecture/components/use-cases.md) |
| `lib/data/repositories/`, `lib/data/services/` | Repositories; stateless API wrappers | [Data Layer](../architecture/components/data.md) |
| `lib/config/` | `providers/`, `AppConfig`, logging, error hooks, app status | [Config Layer](../architecture/components/config.md) |
| `lib/utils/` | `Result`, `AppError`, `CommonErrors`, ports | [Utils Layer](../architecture/components/utils.md) |
| `lib/app.dart`, `lib/main.dart` | Root widget, entry point | [Flutter App](../architecture/containers/app/flutter-app.md) |
| `env/` | `dev.json`, `stg.json`, `prod.json` | [Configuration and Environments](../architecture/cross-cutting/configuration.md) |
| `tool/` | Mock API, dev server, `check_coverage.dart` | [Mock Email API](../architecture/containers/mock-api/mock-email-api.md), [Generate Coverage](../workflows/engineering/generate-coverage.md) |
| `test/`, `integration_test/` | All tests | [Test Architecture](../architecture/delivery/test-architecture.md) |
| `.okf/` | This bundle | [Maintain the Knowledge Base](../workflows/process/maintain-the-knowledge-base.md) |
| `android/`, `ios/` | Platform projects | - |
| `../.github/`, `../.githooks/` | CI workflow, Dependabot, pre-commit hook (monorepo root, scoped to `flutter/`) | [CI Pipeline](delivery/ci-pipeline.md) |

Also: `pubspec.yaml` (dependencies), `analysis_options.yaml` (lints), `build.yaml` (json_serializable options), `l10n.yaml` (gen-l10n),

