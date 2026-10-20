---
type: Convention
title: "Goldens"
description: "Golden images are rendered on Linux, the CI platform; golden tests carry the golden tag so other platforms can skip them."
resource: dart_test.yaml
tags: [convention, testing, golden]
status: stable
---
# Goldens

Linux/CI goldens are canonical. Font hinting and anti-aliasing differ between macOS and Linux (and between Flutter
releases), so one image cannot match every machine. CI on `ubuntu-latest` decides.

| Rule | How |
|---|---|
| Every golden test is tagged | `@Tags(['golden'])` + `library;` at the top of the file; the tag is declared in `dart_test.yaml` |
| CI runs everything | `flutter test --coverage`, goldens included |
| Local on macOS or Windows | `flutter test --exclude-tags golden` |
| Regenerate after an intended visual change | `tool/update_goldens.sh [test paths]` (Docker, linux/amd64, Flutter version from `flutter-ci.yml`), then review the PNG diff |

Correct: `tool/update_goldens.sh test/ui/emails/email_tile_golden_test.dart`.
Incorrect: `flutter test --update-goldens` on a Mac and committing the result, which fails CI.
