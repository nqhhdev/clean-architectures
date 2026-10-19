---
type: Pattern
title: "Test Robot"
description: "E2E tests talk to a robot class that hides keys and finders, so tests read as user actions."
resource: integration_test/robots/inbox_robot.dart
tags: [pattern, testing, e2e]
status: stable
---
# Test Robot

One robot per screen in `integration_test/robots/`. Methods are verbs and checks (`tapEmail`, `deleteEmail`,
`seeUnread`, `seeSessionExpiredBanner`); finders and `Key`s live only in the robot. Static helpers reset or fail the
mock server. Used by [`inbox_e2e_test.dart`](../../../integration_test/inbox_e2e_test.dart) via
[`InboxRobot`](../../../integration_test/robots/inbox_robot.dart). tmail-flutter uses the same idea with Patrol ([Reference](../../references/tmail-flutter.md)).
