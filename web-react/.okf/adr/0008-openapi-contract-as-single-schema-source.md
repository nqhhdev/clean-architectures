---
type: ADR
title: "ADR 0008: openapi/emails.yaml is the single schema source; orval generates types and zod schemas"
description: "One OpenAPI file in this stack drives TS types and zod schemas; it is replaced by the real .NET spec by changing one path or URL."
tags: [adr, openapi, orval, contract]
status: stable
---
# ADR 0008: openapi/emails.yaml is the single schema source; orval generates types and zod schemas

**Status:** Accepted - 2026-10-19.

## Context
No machine-readable contract for the .NET API exists in this repository. The web and Flutter stacks should check against
one contract, and DTO shapes must not be written twice.

## Decision
`web-react/openapi/emails.yaml` is the single source of truth for API shapes. A generation script runs
[orval](https://orval.dev) on it and writes TS types and zod schemas into a git-ignored folder; CI regenerates them on
every run. Nothing else defines a DTO. When the real .NET spec is available, the generation script's input is switched to
its path or URL and the minimal file is deleted; no other code changes.

**Why orval.** It is actively released, can emit zod schemas (and types) from OpenAPI, can later emit TanStack Query clients if
wanted, and configures from one file. `openapi-zod-client` was considered: it targets a Zodios client rather than TanStack
Query. Version and output of orval's zod mode are confirmed in the API client step before anything depends on it. **Verified 2026-10-19 (step 4):** orval 8.43.0, `client: 'zod'` emits zod 4 schemas (`zod.iso.datetime`) that the HTTP client parses with; types and MSW handlers come from a second `fetch`-client target whose generated fetch functions are unused. Zod output covers success responses only, not the error envelope.

## Consequences
**Good.** One schema source; the contract is checkable by both stacks.
**Costly.** A hand-written contract can drift from the real API until it is replaced; CI depends on the generator.
**Alternatives rejected.** `openapi-typescript` plus hand-written zod: two sources. Hand-written client and schemas: drift.

## When to revisit
When the real spec exists, or if orval's zod output does not meet [ADR 0005](0005-zod-at-the-data-boundary.md).
