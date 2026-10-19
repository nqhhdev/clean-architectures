---
type: Pattern
title: "Build-Time Configuration"
description: "A setting is a key in env/*.json, parsed once in AppConfig.resolve and injected through appConfigProvider."
resource: lib/config/env.dart
tags: [pattern, configuration]
status: stable
---
# Build-Time Configuration

**When:** a value differs per environment and is not a secret.

1. Add the key to every [`env/*.json`](../../../env/dev.json).
2. Read it in `AppConfig.fromEnvironment` with `const String.fromEnvironment('KEY')` and validate it in `AppConfig.resolve`
   (throw `ConfigurationError` in release when it is missing).
3. Add a final field to `AppConfig`; consumers read `ref.watch(appConfigProvider).<field>` inside `config/providers/`.
4. Cover debug fallback and release failure in [`env_test.dart`](../../../test/config/env_test.dart).

**Pitfalls:** `String.fromEnvironment` anywhere else, or reading config from widgets.
**Used in:** [`AppConfig`](../../../lib/config/env.dart). Mechanism: [Configuration and Environments](../../architecture/cross-cutting/configuration.md).
