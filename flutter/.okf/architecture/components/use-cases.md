---
type: Component
title: "Use Case Layer"
description: "Optional domain/use_cases: one callable class per user action, between repositories and ViewModels."
resource: lib/domain/use_cases
tags: [layer, domain, use-cases]
status: stable
---
# Use Case Layer

`lib/domain/use_cases/`, decided in [ADR 0010](../../adr/0010-use-cases-layer.md). Pure Dart; depends on repository interfaces only.

| Use case | Repository call |
|---|---|
| [`ListEmailsUseCase`](../../../lib/domain/use_cases/list_emails_use_case.dart) | `getAll`, then newest first |
| [`ToggleEmailReadUseCase`](../../../lib/domain/use_cases/toggle_email_read_use_case.dart) | `setRead(id, isRead: !isRead)` |
| [`DeleteEmailUseCase`](../../../lib/domain/use_cases/delete_email_use_case.dart) | `delete(id)` |

Provided in [`email_providers.dart`](../../../lib/config/providers/email_providers.dart); called by [`EmailsViewModel`](../../../lib/ui/emails/emails_view_model.dart).
Tests: [`email_use_cases_test.dart`](../../../test/domain/use_cases/email_use_cases_test.dart). Allowed imports: [Layered Architecture](../cross-cutting/layered-architecture.md).
