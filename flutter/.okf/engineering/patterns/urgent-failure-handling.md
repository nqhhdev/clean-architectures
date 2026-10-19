---
type: Pattern
title: "Urgent Failure Handling"
description: "Ask the UrgentFailureHandler first on every repository failure; skip your own error UI when it handled it."
resource: lib/ui/emails/emails_view_model.dart
tags: [pattern, errors, session]
status: stable
---
# Urgent Failure Handling

```dart
EmailsState _failed(AppError error) {
  final handled = ref.read(urgentFailureHandlerProvider).handle(error);
  return EmailsState(emails: state.value?.emails ?? const [], error: handled ? null : error);
}
```
Never call `clear()` from a ViewModel: `ApiClient.onResponse` clears each type on a real response ([ADR 0019](../../adr/0019-urgent-failure-clearing-and-async-rules.md)).
Decision: [ADR 0004](../../adr/0004-urgent-failures-single-handler.md).
**Used in:** [`EmailsViewModel`](../../../lib/ui/emails/emails_view_model.dart); handler in [`app_status.dart`](../../../lib/config/app_status.dart).
