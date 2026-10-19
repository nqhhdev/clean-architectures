---
type: Reference
title: "Troubleshooting by Symptom"
description: "Common failure symptoms in this stack, each mapped to its likely cause and the concept that explains it."
tags: [troubleshooting]
status: stable
---
# Troubleshooting by Symptom

| Symptom | Likely cause | Read |
|---|---|---|
| `Target of URI hasn't been generated: '*.freezed.dart'` / `*.g.dart` | Generated code is git-ignored and not built yet | [Build and Test](workflows/engineering/build-and-test.md) |
| `AppLocalizations` or `generated/app_localizations.dart` missing | gen-l10n has not run (`flutter pub get`) | [Localization](architecture/cross-cutting/localization.md) |
| Architecture test: `layer "X" must not depend on "Y"` | An import points the wrong way | [Layered Architecture](architecture/cross-cutting/layered-architecture.md) |
| `only config/ and root files may import repository implementations` | `ui/` or a use case imported a `*_remote.dart` / `*_local.dart` | [Config Layer](architecture/components/config.md) |
| `not inside a known layer` | A new folder under `lib/` is not one of the layers | [Solution Layout](architecture/solution-layout.md) |
| `layer "domain" must not import Flutter` | A restricted layer pulled in Flutter, Riverpod or go_router | [Layered Architecture](architecture/cross-cutting/layered-architecture.md) |
| `must declare class ...` / `belongs in a *_x.dart file` | File and class suffix disagree | [Naming and Placement](engineering/conventions/naming.md) |
| `inline TextStyle; use the theme` | A widget built a `TextStyle` | [Theming](architecture/cross-cutting/theming.md) |
| `ref.read inside build(); use ref.watch` | ViewModel will not reload when a provider changes | [State Management](architecture/cross-cutting/state-management.md) |
| `ConfigurationError` at startup | Release build without `--dart-define-from-file=env/<env>.json`, or http in prod | [Configuration and Environments](architecture/cross-cutting/configuration.md) |
| l10n test: a code has no message | New `AppError` code without ARB entry / `errorMessage` arm | [Localization](architecture/cross-cutting/localization.md) |
| Golden test fails after an intended UI change | Golden is stale | [Build and Test](workflows/engineering/build-and-test.md) |
| `line coverage ... threshold` exits 1 | Coverage below 80% | [Generate Coverage](workflows/engineering/generate-coverage.md) |
| Offline banner stays though the server is up | No HTTP response has arrived since; cache hits do not clear it | [ADR 0019](adr/0019-urgent-failure-clearing-and-async-rules.md) |
| A second tap does nothing | In-flight guard: an action is still running | [ADR 0019](adr/0019-urgent-failure-clearing-and-async-rules.md) |
| E2E: `Mock server not reachable` | The server is not running, or `API_BASE_URL` is wrong | [Run E2E Tests](workflows/engineering/run-e2e-tests.md) |
| `okf.py` reports an index problem | A new file is not listed, or a description drifted | [Maintain the Knowledge Base](workflows/process/maintain-the-knowledge-base.md) |

Android-specific symptoms are not covered: [Android verification](backlog/android-verification.md).
