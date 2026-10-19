---
type: Constraint
title: "Constraints"
description: "Every rule the code must keep, what enforces it, and the page that owns the reasoning - re-check before you finish."
tags: [architecture-tests, rules, review]
status: stable
---
# Constraints

`dart run build_runner build -d && flutter analyze && flutter test` must pass before any work is complete. **A failing architecture
test is a design error, not a test to loosen.** To change a rule, write or supersede an [ADR](../adr/index.md) first, then the test and code.
"layers_test: X" = the test named X in `test/architecture/layers_test.dart` (checkers in `layer_rules.dart`). "review" = nothing automated.

| Rule | Enforced by | Owner |
|---|---|---|
| Each layer imports only what `allowedImports` allows | layers_test: layer dependencies and Flutter bans | [Layered Architecture](../architecture/cross-cutting/layered-architecture.md) |
| `utils`, `domain`, `domain/use_cases` import no Flutter; `data/services` only `services.dart`, `foundation.dart`; `data/repositories` only `foundation.dart` | layers_test: layer dependencies and Flutter bans (`flutterAllowlist`) | [Layered Architecture](../architecture/cross-cutting/layered-architecture.md) |
| Those layers never import `package:riverpod`, `package:go_router`, `dart:ui` | layers_test: layer dependencies and Flutter bans | [Layered Architecture](../architecture/cross-cutting/layered-architecture.md) |
| Repositories do not import other features' repositories | layers_test: layer dependencies and Flutter bans | [Data Layer](../architecture/components/data.md) |
| `*_local.dart` / `*_remote.dart` are imported only from `config/` and root files | layers_test: layer dependencies and Flutter bans | [Config Layer](../architecture/components/config.md) |
| Every file under `lib/` is in a known layer or is a root file (generated files exempt) | layers_test: layer dependencies and Flutter bans | [Layered Architecture](../architecture/cross-cutting/layered-architecture.md) |
| `_view_model.dart`, `_screen.dart` (ui), `_repository[_remote/_local].dart`, `_service.dart`, `_use_case.dart` declare the matching class, and such classes live only there | layers_test: naming | [Naming and Placement](conventions/naming.md) |
| No `TextStyle(` under `ui/` outside `ui/core/theme/` | layers_test: no inline TextStyle outside the theme | [ADR 0016](../adr/0016-theme.md) |
| No `ref.read` inside a Notifier `build()`; use `ref.watch` | layers_test: no ref.read inside a Notifier build() | [ADR 0014](../adr/0014-strict-lints-and-architecture-stand-ins.md) |
| The checkers themselves catch bad sources | layers_test: the checkers catch violations | [Layered Architecture](../architecture/cross-cutting/layered-architecture.md) |
| `package:clean_architecture/...` imports in `lib/`, never relative; analyzer-clean under very_good_analysis and strict modes | `flutter analyze` (`always_use_package_imports`) | [Dart Style](conventions/dart-style.md) |
| Code is formatted | CI `dart format --set-exit-if-changed`; optional pre-commit hook | [Dart Style](conventions/dart-style.md) |
| Generated code is git-ignored and rebuilt, never committed | `.gitignore`; CI runs `build_runner` | [ADR 0011](../adr/0011-code-generation-freezed-json.md) |
| Line coverage of non-generated code >= 80% | CI `tool/check_coverage.dart 80` | [Generate Coverage](../workflows/engineering/generate-coverage.md) |
| Domain models: freezed, private constructor, validated `create` returning `Result` | review; `test/domain/models/email_test.dart` | [Entity Factory Method](patterns/entity-factory-method.md) |
| Time and ids are passed in, not read inside models | review | [Domain Layer](../architecture/components/domain.md) |
| Errors are codes; every code has a message in every locale; ARB keys match | `test/ui/core/l10n_test.dart` | [Localization](../architecture/cross-cutting/localization.md) |
| User-facing strings only from ARB; no inline `Color(` | review | [ADR 0015](../adr/0015-localization-gen-l10n.md), [ADR 0016](../adr/0016-theme.md) |
| Business and transport failures are `Result`, not thrown above `data/` | `test/data/` (repository and service tests) | [Error Handling](../architecture/cross-cutting/error-handling.md) |
| Only `ApiClient` uses `package:http`; services are stateless and return DTOs | review; `test/data/services/` | [ADR 0018](../adr/0018-data-layer-api-client-dtos-errors.md) |
| Wrong-typed JSON becomes `ApiFailure.malformed`; invalid list items are skipped and logged | `email_api_service_test.dart`, `email_repository_remote_test.dart` | [ADR 0018](../adr/0018-data-layer-api-client-dtos-errors.md) |
| Remote repositories are cache-first and refetch after writes | `test/data/repositories/emails/email_repository_remote_test.dart` | [Caching](../architecture/cross-cutting/caching.md) |
| ViewModels route urgent failures through the handler and never call `clear` | `test/ui/emails/emails_view_model_test.dart`, integration tests | [Urgent Failure Handling](patterns/urgent-failure-handling.md) |
| Urgent state clears per type, only on a real HTTP response | `test/config/app_status_test.dart`, `test/integration/inbox_integration_test.dart` | [ADR 0019](../adr/0019-urgent-failure-clearing-and-async-rules.md) |
| ViewModel actions: in-flight guard, `ref.mounted` after `await` | `emails_view_model_test.dart` group "async rules" | [View Model](patterns/view-model.md) |
| Each piece of shared state has one owning notifier | review | [ADR 0005](../adr/0005-single-source-of-truth-for-state.md) |
| Views contain no business logic | review | [View Model](patterns/view-model.md) |
| Config is read only in `AppConfig`; release fails fast | `test/config/env_test.dart`; review for other `fromEnvironment` reads | [Configuration and Environments](../architecture/cross-cutting/configuration.md) |
| Escaped errors reach the `CrashReporter` | `test/config/error_hooks_test.dart` | [Observability](../architecture/cross-cutting/observability.md) |
| `error` log level only for unrecoverable faults | review | [Logging](conventions/logging.md) |
| Tests use fakes, not mock frameworks; folders mirror `lib/` | review | [Fake over Mock](patterns/fake-over-mock.md) |
| A feature is complete only when every layer that needs a file has one | review | [Add a Feature](../workflows/engineering/add-a-feature.md) |
| S1: no secrets committed; `env/*.json` hold public values only; secrets from CI or keychain | Review (planned: gitleaks in CI and pre-commit, [backlog](../backlog/security-baseline-enforcement.md)) | [ADR 0020](../adr/0020-security-baseline.md), [Security and Authorization](../architecture/cross-cutting/security-and-authorization.md) |
| S2: stg and prod base URLs are https; cleartext only in debug | Review (planned: test over `env/*.json` and manifests; today `env_test.dart` covers prod only, [backlog](../backlog/security-baseline-enforcement.md)) | [ADR 0020](../adr/0020-security-baseline.md), [Security and Authorization](../architecture/cross-cutting/security-and-authorization.md) |
| S3: tokens only through a `SecureStore` port in `utils/`; never SharedPreferences | Review (planned: `layer_rules.dart` check, [backlog](../backlog/security-baseline-enforcement.md)) | [ADR 0020](../adr/0020-security-baseline.md), [Security and Authorization](../architecture/cross-cutting/security-and-authorization.md) |
| S4: logs never contain PII or tokens; the `Logger` redacts | Review (planned: unit test, [backlog](../backlog/security-baseline-enforcement.md)) | [ADR 0020](../adr/0020-security-baseline.md), [Security and Authorization](../architecture/cross-cutting/security-and-authorization.md) |
| S5: release builds use `--obfuscate --split-debug-info` | Review (planned: CI build step, [backlog](../backlog/security-baseline-enforcement.md)) | [ADR 0020](../adr/0020-security-baseline.md), [Security and Authorization](../architecture/cross-cutting/security-and-authorization.md) |
| S6: vulnerable dependencies block merge | Review (planned: Dependabot alerts / `dart pub outdated`, [backlog](../backlog/security-baseline-enforcement.md)) | [ADR 0020](../adr/0020-security-baseline.md), [Security and Authorization](../architecture/cross-cutting/security-and-authorization.md) |
| S7: no request or response body logging in release | Review (planned: `ApiClient` test, [backlog](../backlog/security-baseline-enforcement.md)) | [ADR 0020](../adr/0020-security-baseline.md), [Security and Authorization](../architecture/cross-cutting/security-and-authorization.md) |
