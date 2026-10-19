---
type: Workflow
title: "Generate Coverage"
description: "Produce an lcov report from the headless tests and fail below the 80% line-coverage threshold."
resource: tool/check_coverage.dart
tags: [workflow, coverage]
status: stable
---
# Generate Coverage

```bash
flutter test --coverage                      # writes coverage/lcov.info (git-ignored)
dart run tool/check_coverage.dart 80         # exit 1 below 80% (default 70 without an argument)
```
[`check_coverage.dart`](../../../tool/check_coverage.dart) excludes `*.g.dart`, `*.freezed.dart` and `/generated/`. CI uses
`COVERAGE_THRESHOLD: "80"` ([CI Pipeline](../../architecture/delivery/ci-pipeline.md)). An HTML report needs `lcov`/`genhtml`, not part of the stack.
