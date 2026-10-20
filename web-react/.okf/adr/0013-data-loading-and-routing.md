---
type: ADR
title: "ADR 0013: Query defaults, per-feature query keys and a router context with guards in beforeLoad"
description: "TanStack Query defaults and key conventions, plus TanStack Router context, beforeLoad guards, loaders that prefetch and nested error components."
tags: [adr, tanstack-query, tanstack-router, routing, data-loading]
status: stable
---
# ADR 0013: Query defaults, per-feature query keys and a router context with guards in beforeLoad

**Status:** Accepted - 2026-10-19. Extends [ADR 0003](0003-state-management.md) and [ADR 0004](0004-tanstack-router.md); neither is superseded.

## Context
ADR 0003 says server state lives in TanStack Query and ADR 0004 says TanStack Router owns navigation with guards in
`beforeLoad`. Neither fixes the client defaults, the key conventions, or how services reach loaders.

## Decision
**Query.**
* `QueryClient` defaults: `refetchOnWindowFocus: false`; mutations `retry: false`; queries do not retry when the thrown
  `QueryError` ([ADR 0012](0012-result-and-app-error.md)) has kind `refused`, `unauthorized` or `invalid` (4xx
  responses and parse failures are deterministic), otherwise they retry while `count < 2`.
* Each feature has key constants (`emailKeys.all`, `emailKeys.list(filter)`) and `queryOptions()` factories in
  `queries.ts`. Components never write inline key arrays.
* Mutations invalidate in `onSettled`, not `onSuccess`.
* `queries.ts` replaces the "repository" and "view-model hook" wording of ADR 0003: ports do the fetching, `queries.ts`
  holds keys, options and mutations.

**Routing.**
* Typed router context `{ queryClient, services }` (step 10 dropped `session`: the guard reads the service after the bootstrap, so a context snapshot would only go stale). Route definitions live in `app/`, which may import feature
  screens and `queries.ts`.
* The auth check is a `beforeLoad` on the authenticated layout route and redirects to sign-in. Guards are never
  component effects.
* Loaders call `queryClient.ensureQueryData(feature.queryOptions(services))` with `services` from router context; they
  never call a hook. Components read the same options with `useSuspenseQuery` or `useQuery`.
* `errorComponent` sits on the root route and on the shell route (so navigation survives a page error); `notFound` is
  handled at the root.

**Built in step 8.** TanStack Query 5.104 marks `ensureQueryData` deprecated (lint `no-deprecated`), so the loader calls `queryClient.query({ ...emailsQueryOptions(services), staleTime: 'static' })`, which returns cached data like `ensureQueryData` and fetches otherwise (decided by builder, awaiting owner review).

## Consequences
**Good.** One place per feature for keys and fetching options; loaders and components share options, so prefetch and
read cannot drift; a failing page does not take the shell down.
**Costly.** `queryOptions` factories take `services` as an argument, which is more plumbing than a hook; the retry rule
depends on `QueryError` carrying the `AppError`.
**Alternatives rejected.** Library defaults (three retries on every error): retries 4xx. Guards in effects: flashes
protected content before redirecting.

## When to revisit
When a feature needs different retry or stale-time behaviour often enough that per-query overrides become the norm.
