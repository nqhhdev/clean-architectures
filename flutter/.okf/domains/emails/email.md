---
type: Entity
title: "Email"
description: "An immutable freezed email with id, subject, sender, preview, receivedAt (UTC) and isRead."
resource: lib/domain/models/email.dart
tags: [entity, email]
status: stable
---
# Email

Created only through `Email.create`, which rejects a blank id, trims subject and sender and stores `receivedAt` as UTC. A blank
subject stays empty; [`EmailTile`](../../../lib/ui/emails/email_tile.dart) shows `noSubject` from the ARB files.
Wire format: [`EmailDto`](../../../lib/data/services/model/email_dto.dart) (`from` maps to `sender`).
Errors: [Email Errors](email-errors.md). Pattern: [Entity Factory Method](../../engineering/patterns/entity-factory-method.md).
