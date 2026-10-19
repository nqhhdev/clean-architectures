---
type: Mechanism
title: "Configuration and Environments"
description: "dev, stg and prod are env JSON files plus native flavors; AppConfig resolves them once at startup."
resource: lib/config/env.dart
tags: [configuration, environments, flavors]
status: stable
---
# Configuration and Environments

| Environment | Env file | `API_BASE_URL` | Android flavor (id suffix) | iOS scheme |
|---|---|---|---|---|
| dev | [`env/dev.json`](../../../env/dev.json) | `http://127.0.0.1:8080` | `dev` (`.dev`) | `dev` |
| stg | [`env/stg.json`](../../../env/stg.json) | `https://api.stg.example.com` | `stg` (`.stg`) | `stg` |
| prod | [`env/prod.json`](../../../env/prod.json) | `https://api.example.com` | `prod` (none) | `prod` |

* Pass both: `--flavor <env> --dart-define-from-file=env/<env>.json` ([Run the App](../../workflows/engineering/run-the-app.md)).
* [`AppConfig.fromEnvironment`](../../../lib/config/env.dart) runs once in [`main.dart`](../../../lib/main.dart) and is injected
  through `appConfigProvider`.
* Release: missing `ENV` or `API_BASE_URL` throws `ConfigurationError`; prod must be https. Debug/profile fall back to dev and `AppConfig.debugDefaultBaseUrl`.
* Native: [`build.gradle.kts`](../../../android/app/build.gradle.kts) `productFlavors` (also `app_name`); iOS `Debug-/Profile-/Release-<env>` configurations.

Adding a setting: [Build-Time Configuration](../../engineering/patterns/build-time-configuration.md). Decision: [ADR 0013](../../adr/0013-environments-and-flavors.md).
Tests: [`env_test.dart`](../../../test/config/env_test.dart).
