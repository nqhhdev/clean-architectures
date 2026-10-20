---
type: ADR
title: "ADR 0002: Result<T> for expected failures, exceptions for the unexpected"
description: "Return business and transport failures as Result values so they are visible in signatures; keep exceptions for bugs and faults."
tags: [adr, errors, result]
status: deprecated
---
# ADR 0002: Result<T> for expected failures, exceptions for the unexpected

**Status:** Superseded by ADR 0012 (`0012-result-and-app-error.md`) - 2026-10-19. Originally accepted 2026-10-19.

## Context
TypeScript signatures do not show which functions throw. Failures such as validation errors, 4xx responses or a lost
network are expected outcomes, not faults, and callers should be forced to handle them.

## Decision
Functions in `domain` and `data` that can fail for expected reasons return `Result<T>`: `Success` or `Failure` carrying an
`AppError` with a stable code. Exceptions are for bugs and faults and reach the global error hooks. Transport errors are
converted to `Failure` inside `data/`; nothing above `data/` catches them.

## Consequences
**Good.** Failure cases appear in types; error codes map to translated text in one place.
**Costly.** Every caller handles both arms; third-party code that throws needs a wrapper at the boundary.
**Alternatives rejected.** Throwing typed errors: invisible in signatures. A library such as neverthrow: one more
dependency for a type of about twenty lines.

## When to revisit
If the team decides to lean on TanStack Query's own error channel everywhere and drop `Result` above `data/`.
