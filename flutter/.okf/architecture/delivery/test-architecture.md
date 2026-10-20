---
type: Mechanism
title: "Test Architecture"
description: "The test tiers, where each lives, what it proves and how to run it."
resource: test
tags: [testing, e2e, integration]
status: stable
---
# Test Architecture

| Tier | Where | Proves | Run |
|---|---|---|---|
| Architecture | `test/architecture/` | layer, naming, theme and `ref.read` rules hold; the checkers catch bad sources | `flutter test test/architecture` |
| Unit | `test/domain/`, `test/data/`, `test/config/`, `test/ui/**/*_view_model_test.dart` | models, use cases, `ApiClient` and service (via `MockClient`), repository (fake service), config, ViewModel | `flutter test` |
| Widget | `test/ui/**/*_screen_test.dart`, `test/ui/core/` | screens, router redirect, theme, l10n completeness | `flutter test` |
| Golden | `test/ui/emails/email_tile_golden_test.dart` + `goldens/` | `EmailTile` pixels | `flutter test` in CI, tag `golden` ([Goldens](../../engineering/conventions/goldens.md); `tool/update_goldens.sh` to regenerate) |
| Headless integration | `test/integration/` | real providers + service + repository + JSON against the in-process `MockEmailApi` | `flutter test` |
| Device e2e | `integration_test/` | the real app on a simulator over HTTP to the mock server, driven by a [robot](../../engineering/patterns/test-robot.md) | [Run E2E Tests](../../workflows/engineering/run-e2e-tests.md) |

Folders mirror `lib/`. Shared helpers: `test/support/` (builders, fakes, mock client, `pump_app.dart`) and `tool/mock_email_api.dart`.
Coverage gate: [Generate Coverage](../../workflows/engineering/generate-coverage.md). Rules: [Constraints](../../engineering/constraints.md).
Decision: [ADR 0007](../../adr/0007-test-pyramid-and-device-e2e.md).
