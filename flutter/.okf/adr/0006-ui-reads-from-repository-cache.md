---
type: ADR
title: "ADR 0006: Remote repositories are cache-first and refresh after writes"
description: "The UI renders what the repository holds; the repository fills a cache from the service and refetches it after every successful write."
tags: [adr, caching, repository]
status: stable
---
# ADR 0006: Remote repositories are cache-first and refresh after writes

**Status:** Accepted - 2026-10-19. Idea from tmail-flutter `docs/adr/0017` ([Reference](../references/tmail-flutter.md)).
Consistent with the official guide: the repository is the source of truth and owns caching and refresh.

## Context
When screens show raw backend responses, the same data can appear differently depending on which call produced it.

## Decision
[`EmailRepositoryRemote`](../../lib/data/repositories/emails/email_repository_remote.dart) keeps the list in memory.
`getAll()` returns the cache unless `forceRefresh` is set or nothing is cached; every successful write is followed by
a forced refetch. A failed refresh reports the error and keeps the previous cache; a failed first read caches nothing.
See [Caching](../architecture/cross-cutting/caching.md).

## Consequences
**Good.** One consistent view; behaviour pinned by
[`email_repository_remote_test.dart`](../../test/data/repositories/emails/email_repository_remote_test.dart).
**Costly.** An extra GET after each write; the cache is in memory only (lost on restart, no change feed).
**Alternatives rejected.** Optimistic local edits without refetch (drift risk).

## When to revisit
When the server offers a change feed or the app needs offline use: persist the cache and sync incrementally.
