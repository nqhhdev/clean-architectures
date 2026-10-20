---
type: ADR
title: "ADR 0003: TanStack Query for server state, React state for local UI state"
description: "Server data lives in the query cache; local UI state uses React state and context; each shared piece has one owner."
tags: [adr, state, tanstack-query]
status: stable
---
# ADR 0003: TanStack Query for server state, React state for local UI state

**Status:** Accepted - 2026-10-19. See also [ADR 0013](0013-data-loading-and-routing.md): ports and `queries.ts` replace the repositories and view-model hooks named below.

## Context
Most state in an SPA is server data with caching, refetching and invalidation concerns. The rest is small UI state.

## Decision
Server state is owned by TanStack Query: repositories fetch, view-model hooks read through queries and invalidate after
writes. Local UI state uses `useState`, `useReducer` or context, kept as close to its component as possible. A piece of
state shared by several screens has exactly one owner (a query, or one context provider); screens read and write through
it. No client-side store library is installed.

## Consequences
**Good.** One caching mechanism; fewer dependencies.
**Costly.** State shared widely across unrelated screens must go through context, which re-renders consumers.
**Alternatives rejected.** Adding Zustand now: nothing needs it yet, and a store invites copies of server data.

## When to revisit
When shared UI state becomes awkward with context. Adding a store then needs a new ADR.
