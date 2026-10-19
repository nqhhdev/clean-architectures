---
type: Technology
title: "integration_test"
description: "Flutter SDK package that runs tests in the real app on a device or simulator."
resource: pubspec.yaml
tags: [technology, e2e, testing]
status: stable
---
# integration_test

SDK package (dev dependency). Runs `integration_test/` on a booted simulator/device with `flutter test integration_test/... -d <id>`.
Cannot drive native dialogs or webviews; Patrol can ([ADR 0007](../../adr/0007-test-pyramid-and-device-e2e.md)).
