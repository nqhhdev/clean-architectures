---
type: Workflow
title: "Run Flavors"
description: "Run the app per environment (flavor), with the matching entry point and config."
tags: [workflow, run, flavor]
status: draft
---
# Run Flavors

| Flavor | Command | Config | Backend |
|---|---|---|---|
| `<dev>` | `flutter run --flavor dev -t lib/main_dev.dart` | `<--dart-define-from-file=env/dev.json>` | `<mock / dev>` |
| `<stg>` | `<...>` | `<...>` | `<...>` |
| `<prod>` | `<...>` | `<...>` | `<...>` |

**Choose** how flavors are configured: native flavors (Android product flavors, iOS schemes), separate entry points,
`--dart-define` / `--dart-define-from-file`, or a combination. Never commit secrets in env files; see [Constraints](../engineering/constraints.md).
