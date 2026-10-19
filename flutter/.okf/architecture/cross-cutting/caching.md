---
type: Mechanism
title: "Caching"
description: "The repository keeps an in-memory cache; reads are cache-first and every write is followed by a refetch."
tags: [caching, repository]
status: stable
---
# Caching

[`EmailRepositoryRemote`](../../../lib/data/repositories/emails/email_repository_remote.dart) holds `_cache`.

| Call | Behaviour |
|---|---|
| `getAll()` | cache if present, else fetch and store |
| `getAll(forceRefresh: true)` | fetch and replace; on failure keep the old cache |
| `setRead` / `delete` | write, then forced refetch; a failed write does not refetch |

Items that fail `Email.create` are skipped before caching ([ADR 0018](../../adr/0018-data-layer-api-client-dtos-errors.md)). Memory only: lost on restart, no change feed. Decision: [ADR 0006](../../adr/0006-ui-reads-from-repository-cache.md).
Tests: [`email_repository_remote_test.dart`](../../../test/data/repositories/emails/email_repository_remote_test.dart).
