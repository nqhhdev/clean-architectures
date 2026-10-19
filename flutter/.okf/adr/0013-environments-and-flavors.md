---
type: ADR
title: "ADR 0013: Environments as env JSON files plus native flavors"
description: "dev, stg and prod each have an env JSON and a native flavor; release builds fail fast on bad config."
tags: [adr, configuration, flavors, environments]
status: stable
---
# ADR 0013: Environments as env JSON files plus native flavors

**Status:** Accepted - 2026-10-19.

## Context
A single `--dart-define=API_BASE_URL` with a localhost default let a release build silently talk to a dev server, and all
environments shared one bundle id.

## Decision
* [`env/dev.json`, `env/stg.json`, `env/prod.json`](../../env/dev.json) hold `ENV` and `API_BASE_URL`, passed with `--dart-define-from-file`.
* [`AppConfig.fromEnvironment`](../../lib/config/env.dart) is read once in `main` and injected through `appConfigProvider`.
  Release builds throw `ConfigurationError` when a value is missing; prod requires https; debug falls back to dev and `http://127.0.0.1:8080`.
* Android [`productFlavors`](../../android/app/build.gradle.kts) `dev` (`.dev`), `stg` (`.stg`), `prod`; iOS schemes `dev`, `stg`, `prod`
  with `Debug-/Profile-/Release-<flavor>` configurations and matching bundle-id suffixes.
* Run: `flutter run --flavor dev --dart-define-from-file=env/dev.json`.

## Consequences
**Good.** Environments install side by side; misconfiguration fails at startup, tested in [`env_test.dart`](../../test/config/env_test.dart).
**Costly.** Flavor and env file are two flags; nothing checks that they match. Env files are committed, so they hold no secrets.
**Alternatives rejected.** One `main_<env>.dart` per environment (duplicated entry points); per-value `--dart-define` (easy to forget one).

## When to revisit
When secrets or per-environment native config (icons, Firebase files) are needed.
