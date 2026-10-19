---
type: Task
title: "Android verification"
description: "The dev flavor APK builds; running the app and e2e on an emulator against 10.0.2.2 is unverified."
tags: [backlog]
status: draft
---
# Android verification

**Problem.** Run the app and the e2e suite on an Android emulator. `env/dev.json` points at `127.0.0.1`, which an emulator does not reach
(it uses `10.0.2.2`).
Unverified: whether `--dart-define=API_BASE_URL=http://10.0.2.2:8080` overrides `--dart-define-from-file`, or an emulator env file is needed.

**Done when** it is built, documented in `.okf/`, and this file is deleted and logged.
