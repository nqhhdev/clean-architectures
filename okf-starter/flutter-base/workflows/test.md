---
type: Workflow
title: "Test"
description: "Run unit, widget, golden and integration tests, and where golden tests are canonical."
tags: [workflow, test, golden]
status: draft
---
# Test

```sh
flutter test                                   # unit + widget
flutter test --coverage                        # coverage/lcov.info
flutter test integration_test                  # on a device or emulator
```

## Golden tests
Golden images differ between operating systems (font rendering), so **Linux / CI is canonical**.
1. Tag them: `@Tags(['golden'])` on the file and declare the tag in `dart_test.yaml`.
2. On macOS or Windows exclude them: `flutter test --exclude-tags golden`.
3. Run and update them only on Linux or in CI (or a Linux container): `flutter test --tags golden [--update-goldens]`.

**Verify:** `flutter test` exits 0 on CI.
