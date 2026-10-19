---
type: Pattern
title: "Fake over Mock"
description: "Test with small hand-written fakes that implement the interface rather than a mocking framework."
resource: test/support/fakes.dart
tags: [pattern, testing]
status: stable
---
# Fake over Mock

Implement the interface in `test/support/fakes.dart` and script it with plain fields (`failure`, `emails`). Count calls to
make behaviour observable (`getCalls`). The official guide recommends fakes. Examples: `FakeEmailApiService`,
`FakeEmailRepository`, `RecordingUrgentFailureHandler`, `RecordingLogger`, `RecordingCrashReporter` in [`fakes.dart`](../../../test/support/fakes.dart).
