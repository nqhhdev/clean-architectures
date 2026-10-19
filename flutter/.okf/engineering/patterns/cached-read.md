---
type: Pattern
title: "Cached Read"
description: "Read from an in-memory cache first; refresh on demand and after writes; keep the old cache when a refresh fails."
resource: lib/data/repositories/emails/email_repository_remote.dart
tags: [pattern, caching]
status: stable
---
# Cached Read

See [Caching](../../architecture/cross-cutting/caching.md) for the table and [ADR 0006](../../adr/0006-ui-reads-from-repository-cache.md).
**Shape:** `getAll({bool forceRefresh = false})`; assign the cache only after a successful fetch.
**Used in:** [`EmailRepositoryRemote.getAll`](../../../lib/data/repositories/emails/email_repository_remote.dart).
