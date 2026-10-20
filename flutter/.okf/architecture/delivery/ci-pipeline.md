---
type: Mechanism
title: "CI Pipeline"
description: "GitHub Actions checks every pull request; Dependabot opens dependency PRs; an optional pre-commit hook runs the same format and bundle checks locally."
resource: ../.github/workflows/flutter-ci.yml
tags: [ci, dependabot, hooks, github-actions]
status: stable
---

# CI Pipeline

Three pieces, all at the monorepo root (`.github/`, `.githooks/`), scoped to `flutter/`.

## Pull-request checks
[`flutter-ci.yml`](../../../../.github/workflows/flutter-ci.yml) runs on pushes and pull requests to `main` that touch `flutter/**`:
`okf.py --check`, `flutter pub get` (also gen-l10n), `dart run build_runner build -d`, `dart format --set-exit-if-changed`,
`flutter analyze`, `flutter test --coverage`, then `tool/check_coverage.dart` with `COVERAGE_THRESHOLD` 80.
Both third-party actions are pinned by commit SHA (checkout v7.0.1, flutter-action v2.23.0). Flutter is pinned to 3.47.7.
Device e2e is not run in CI; see [Test Architecture](test-architecture.md).

## Automatic dependency updates
[`dependabot.yml`](../../../../.github/dependabot.yml): weekly `pub` updates for `/flutter` (minor/patch grouped; major bumps arrive alone) and
monthly GitHub Actions updates. Dependabot opens pull requests; a person reviews and merges them, and the checks above run on each.
It does **not** bump the Flutter SDK: change `flutter-version` in the workflow and `environment:` in `pubspec.yaml` by hand.

## Pre-commit hook (optional, local)
[`.githooks/pre-commit`](../../../../.githooks/pre-commit) formats staged `.dart` files and re-stages them, refuses partially staged files, and
runs `okf.py --check` when `.okf/` files are staged. Enable once per clone: `git config core.hooksPath .githooks`.

## Status
The hook was tested in a throwaway repository (format and re-stage, bundle failure blocks, partial staging refused). The workflow and Dependabot
config parse as YAML but have **never run on GitHub**; the first run is the real test.
