---
type: Pattern
title: "Entity Factory Method"
description: "Domain models are freezed classes with a private constructor and a validated static create that returns a Result."
resource: lib/domain/models/email.dart
tags: [pattern, domain, result]
status: stable
---
# Entity Factory Method

**When:** any domain model with invariants.

```dart
@freezed
abstract class Email with _$Email {
  const factory Email._internal({required String id /* ... */}) = _Email;

  static Result<Email> create({required String id /* ... */}) {
    if (id.trim().isEmpty) return const Failure(EmailErrors.invalidId);
    return Success(Email._internal(id: id /* ... */));
  }
}
```
**Checklist:** `part '<model>.freezed.dart';` then `dart run build_runner build -d`; normalise (trim, UTC) inside `create`; time and
ids come in as parameters; one error per rule; no JSON on the model (that is the DTO).
**Pitfall:** `copyWith` skips `create`; use it for state changes only ([ADR 0011](../../adr/0011-code-generation-freezed-json.md)).
**Used in:** [`Email`](../../../lib/domain/models/email.dart), tested in [`email_test.dart`](../../../test/domain/models/email_test.dart).
