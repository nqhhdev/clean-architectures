---
type: Workflow
title: "Run E2E Tests"
description: "Run the device e2e suite on a simulator against the mock server, with the dev flavor."
tags: [workflow, e2e, testing]
status: draft
---
# Run E2E Tests

```bash
dart run tool/mock_server.dart &                                   # backend on :8080
flutter test integration_test/inbox_e2e_test.dart -d <simulator id> --flavor dev --dart-define-from-file=env/dev.json
```
Unverified: the suite passed (3 scenarios, iPhone 17 simulator, 2026-10-19) before flavors existed; the flavored command above has not been run on a device.
Android: [Android verification](../../backlog/android-verification.md).
**If it fails:** `Mock server not reachable` means the server is not running or the base URL is wrong. Design: [Test Architecture](../../architecture/delivery/test-architecture.md).
