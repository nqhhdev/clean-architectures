---
type: ADR
title: "ADR 0005: Generated zod schemas parse every API response at the data boundary"
description: "Responses are parsed by schemas generated from the OpenAPI file, mapped to domain models, and invalid list items are skipped and logged; hand-written zod is only for env."
tags: [adr, zod, dto, data]
status: stable
---
# ADR 0005: Generated zod schemas parse every API response at the data boundary

**Status:** Accepted - 2026-10-19. Depends on [ADR 0008](0008-openapi-contract-as-single-schema-source.md).

## Context
TypeScript types vanish at runtime, so a response that does not match the contract would flow into the UI unchecked.

## Decision
Every API response is parsed at the `data` boundary by the zod schema generated from the OpenAPI file; DTO types are the
generated ones. Repositories map DTOs to domain models; DTOs never leave `data/`. A response that fails parsing becomes a
`Failure` with a malformed-response code. In a list, items that fail parsing are skipped and logged, the rest are kept.
Hand-written zod is used only for `import.meta.env` in `config/env.ts`.

## Consequences
**Good.** One schema source; runtime-checked boundary; the domain stays free of transport shapes.
**Costly.** Parsing cost on every response; the mapper is a second step per feature.
**Alternatives rejected.** Hand-written DTO schemas next to a generated client: two sources of truth that can disagree.

## When to revisit
If parse cost shows up in profiling for large lists.
