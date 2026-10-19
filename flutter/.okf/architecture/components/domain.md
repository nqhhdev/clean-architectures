---
type: Component
title: "Domain Layer"
description: "Immutable freezed models and their error codes; pure Dart, imports only utils."
resource: lib/domain
tags: [layer, domain]
status: stable
---
# Domain Layer

`lib/domain/models/` and `lib/domain/errors/`. Pure Dart: only `utils` and `freezed_annotation` / `meta`.

* `models/` - `@freezed` models with a private constructor and a validated `static Result<T> create(...)`, e.g.
  [`Email`](../../../lib/domain/models/email.dart) ([ADR 0011](../../adr/0011-code-generation-freezed-json.md)).
  Pattern: [Entity Factory Method](../../engineering/patterns/entity-factory-method.md).
* `errors/` - feature `AppError` codes, e.g. [`EmailErrors`](../../../lib/domain/errors/email_errors.dart); common ones are in [Utils](utils.md).
* `use_cases/` is its own layer: [Use Case Layer](use-cases.md).

Allowed imports: [Layered Architecture](../cross-cutting/layered-architecture.md).
