---
type: ADR
title: "ADR 0004: TanStack Router"
description: "Typed routes and search params, with guards in beforeLoad."
tags: [adr, routing, tanstack-router]
status: stable
---
# ADR 0004: TanStack Router

**Status:** Accepted - 2026-10-19. See also [ADR 0013](0013-data-loading-and-routing.md) for router context, loaders and error components.

## Context
The SPA needs routing with an auth guard. Route paths and search params are a common source of runtime bugs.

## Decision
TanStack Router owns navigation. Routes and search params are typed; the auth guard is a `beforeLoad` that redirects to a
placeholder sign-in. Router and Query share a `QueryClient` through router context.

## Consequences
**Good.** Type-checked links and search params; guards and loaders sit in the route definition; fits TanStack Query.
**Costly.** A smaller community than React Router; fewer ready-made answers.
**Alternatives rejected.** React Router 7: widely known and lower risk, but weaker typing of paths and search params.

## When to revisit
If TanStack Router maintenance stalls or its typing cost outweighs the benefit.
