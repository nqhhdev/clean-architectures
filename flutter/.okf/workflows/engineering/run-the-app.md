---
type: Workflow
title: "Run the App"
description: "Start the mock backend and run a flavor of the app with its env file."
tags: [workflow, run, flavors]
status: stable
---
# Run the App

```bash
flutter pub get && dart run build_runner build -d                       # once per clone / model change
dart run tool/mock_server.dart                                          # terminal 1: backend on 127.0.0.1:8080
flutter run --flavor dev --dart-define-from-file=env/dev.json -d <device id>   # terminal 2
```
* Other environments: `--flavor stg --dart-define-from-file=env/stg.json`, same for `prod`; flavor and file must match
  ([Configuration and Environments](../../architecture/cross-cutting/configuration.md)).
* `flutter devices` lists ids. `env/dev.json` points at `127.0.0.1:8080`, which iOS simulators reach.
* A release build without the env file stops with `ConfigurationError`.

**Verified:** `flutter build ios --simulator --debug --flavor dev --dart-define-from-file=env/dev.json` and
`flutter build apk --debug --flavor dev --dart-define-from-file=env/dev.json` succeed (2026-10-19). Running on an Android
emulator is tracked in [Android verification](../../backlog/android-verification.md).
