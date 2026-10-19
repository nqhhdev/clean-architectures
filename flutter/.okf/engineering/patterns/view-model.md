---
type: Pattern
title: "View Model"
description: "An AsyncNotifier with an immutable state class holds a screen logic; the View only renders and forwards events."
resource: lib/ui/emails/emails_view_model.dart
tags: [pattern, ui, riverpod]
status: stable
---
# View Model

```dart
class EmailsViewModel extends AsyncNotifier<EmailsState> {
  bool _busy = false; // in-flight guard

  @override
  Future<EmailsState> build() {
    ref.watch(listEmailsUseCaseProvider); // watch in build, read in methods
    return _load();
  }

  Future<void> delete(Email email) {
    final delete = ref.read(deleteEmailUseCaseProvider);
    return _afterWrite(() => delete(email)); // _exclusive + AsyncValue.guard + ref.mounted
  }
}
```
**Checklist:** state immutable; call use cases (or repositories); urgent failures to the handler first ([Urgent Failure Handling](urgent-failure-handling.md));
keep the old list on failure; ignore actions while one runs and check `ref.mounted` after `await` ([ADR 0019](../../adr/0019-urgent-failure-clearing-and-async-rules.md)); no widgets or `BuildContext`.
**Test:** override use-case / repository and handler providers, assert on `container.read(...).requireValue`.
**Used in:** [`EmailsViewModel`](../../../lib/ui/emails/emails_view_model.dart), [test](../../../test/ui/emails/emails_view_model_test.dart).
