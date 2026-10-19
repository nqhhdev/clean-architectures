---
type: Pattern
title: "Repository"
description: "An abstract interface in data/repositories with a remote implementation over a service, a mapper and an in-memory cache."
resource: lib/data/repositories/emails/email_repository_remote.dart
tags: [pattern, data, repository]
status: stable
---
# Repository

**When:** each kind of data the app reads or writes.

1. `<feature>_repository.dart` - abstract interface returning `Result`.
2. `<feature>_mapper.dart` - DTO to domain through the model's `create`.
3. `<feature>_repository_remote.dart` - holds the cache, calls the service, maps `ApiException` with `appErrorFromApi`, skips invalid list items.
4. Register it in `config/providers/<feature>_providers.dart`; use cases and ViewModels read the interface.
5. Test it with a fake service ([`FakeEmailApiService`](../../../test/support/fakes.dart)).

**Pitfalls:** do not import another feature's repository; do not return exceptions; refetch after writes ([Caching](../../architecture/cross-cutting/caching.md)).
**Used in:** [`EmailRepositoryRemote`](../../../lib/data/repositories/emails/email_repository_remote.dart). Decision: [ADR 0018](../../adr/0018-data-layer-api-client-dtos-errors.md).
