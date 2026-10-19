---
type: Workflow
title: "Build and Test"
description: "Install packages, generate code, analyze, format-check and run the headless tests with coverage."
tags: [workflow, build, test]
status: stable
---
# Build and Test

Run from the stack root (`flutter/`). Same order as [CI](../../architecture/delivery/ci-pipeline.md).

```bash
flutter pub get                       # also runs gen-l10n (lib/ui/core/l10n/generated/)
dart run build_runner build -d        # freezed + json_serializable (*.freezed.dart, *.g.dart)
dart format --output=none --set-exit-if-changed lib test tool integration_test
flutter analyze
flutter test                          # unit, widget, golden, headless integration, architecture
flutter test test/architecture        # layer rules only
flutter test --coverage && dart run tool/check_coverage.dart 80
```
Generated files are git-ignored: a fresh clone does not compile until the first two commands ran ([ADR 0011](../../adr/0011-code-generation-freezed-json.md)).
Goldens: `flutter test --update-goldens <file>` only on purpose.
**Verify:** every command exits 0. Device e2e is separate: [Run E2E Tests](run-e2e-tests.md).

