---
type: Mechanism
title: "Vertical Slice Architecture"
description: "A feature spans every layer; each layer keeps a folder or file named after the feature."
tags: [architecture, slice]
status: stable
---
# Vertical Slice Architecture

The layers are the horizontal axis; a feature is the vertical one. The Emails slice:

| Layer | Files |
|---|---|
| domain | `models/email.dart`, `errors/email_errors.dart` |
| data/services | `email_api_service.dart`, `model/email_dto.dart` |
| data/repositories | `emails/email_repository.dart`, `emails/email_repository_remote.dart`, `emails/email_mapper.dart` |
| domain/use_cases | `list_emails_use_case.dart`, `toggle_email_read_use_case.dart`, `delete_email_use_case.dart` |
| config | `providers/email_providers.dart` |
| ui | `emails/emails_screen.dart`, `emails/emails_view_model.dart`, `emails/email_tile.dart`; error codes in `core/l10n/` ARB files |
| tests | mirror `lib/`, see [Test Architecture](../../architecture/delivery/test-architecture.md) |

A feature is complete only when each layer that needs a file has one: [Add a Feature](../../workflows/engineering/add-a-feature.md).
