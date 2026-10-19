---
type: Component
title: "Data Layer"
description: "Repositories (source of truth, caching, mapping) over stateless services that share one ApiClient."
resource: lib/data
tags: [layer, data, repository, service]
status: stable
---
# Data Layer

Two sub-layers, `lib/data/repositories/` and `lib/data/services/` ([ADR 0018](../../adr/0018-data-layer-api-client-dtos-errors.md)).

* **Repository** - source of truth for one kind of data: [`EmailRepository`](../../../lib/data/repositories/emails/email_repository.dart)
  (interface), [`EmailRepositoryRemote`](../../../lib/data/repositories/emails/email_repository_remote.dart) (cache-first, [ADR 0006](../../adr/0006-ui-reads-from-repository-cache.md)),
  [`email_mapper.dart`](../../../lib/data/repositories/emails/email_mapper.dart) (DTO to domain),
  [`api_error_mapper.dart`](../../../lib/data/repositories/api_error_mapper.dart) (`ApiException` to `AppError`).
  Pattern: [Repository](../../engineering/patterns/repository.md).
* **Service** - stateless: [`ApiClient`](../../../lib/data/services/api_client.dart) (all HTTP),
  [`EmailApiService`](../../../lib/data/services/email_api_service.dart) returning [`EmailDto`](../../../lib/data/services/model/email_dto.dart),
  [`ApiException`](../../../lib/data/services/api_exception.dart) for transport faults.

Allowed imports and Flutter allowlist: [Layered Architecture](../cross-cutting/layered-architecture.md).
