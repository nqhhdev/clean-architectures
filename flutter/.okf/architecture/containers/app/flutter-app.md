---
type: Container
title: "Flutter App"
description: "The deployed mobile application: one Flutter binary for iOS and Android."
resource: lib
tags: [container, c4, flutter, mobile]
status: stable
---
# Flutter App

The only deployed container of this stack. Built from `lib/`, entry point [`main.dart`](../../../../lib/main.dart) which
resolves `AppConfig`, installs the error hooks and starts a `ProviderScope` around [`App`](../../../../lib/app.dart). Layers: [Components](../../../architecture/components/index.md).

| Concern | Where |
|---|---|
| Environment and base URL | `--flavor <env> --dart-define-from-file=env/<env>.json`, see [Configuration and Environments](../../cross-cutting/configuration.md) |
| Debug cleartext HTTP on Android | [`debug/AndroidManifest.xml`](../../../../android/app/src/debug/AndroidManifest.xml) |
| Run locally | [Run the App](../../../workflows/engineering/run-the-app.md) |
