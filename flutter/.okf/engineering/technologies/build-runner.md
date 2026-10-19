---
type: Technology
title: "build_runner"
description: "Runs the freezed and json_serializable generators; needed after pub get and after model edits."
resource: pubspec.yaml
tags: [technology, codegen, tooling]
status: stable
---
# build_runner

**Version:** `build_runner ^2.15.1` (dev). **Command:** `dart run build_runner build -d` (`-d` deletes conflicting outputs).
Runs in CI after `flutter pub get` ([CI Pipeline](../../architecture/delivery/ci-pipeline.md)). Does not generate l10n; `flutter pub get` does
([flutter_localizations](flutter-localizations.md)). Steps: [Build and Test](../../workflows/engineering/build-and-test.md).
