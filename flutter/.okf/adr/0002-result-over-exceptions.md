---
type: ADR
title: "ADR 0002: Result<T> for expected failures, exceptions for the unexpected"
description: "Return business and transport failures as Result values so they are visible in signatures; keep exceptions for bugs and faults."
tags: [adr, errors, result]
status: stable
---
# ADR 0002: Result<T> for expected failures, exceptions for the unexpected

**Status:** Accepted - 2026-10-19. Our own choice: the official guide does not prescribe a Result type. Adapted from the
result-pattern decision in `clean-architecture-template`.

## Context
Validation failures, "not found" and "offline" are normal outcomes. If they are thrown, nothing in the type says
so and callers forget to catch them.

## Decision
Model factories and repositories return [`Result<T>`](../../lib/utils/result.dart) (`Success` / `Failure`). A
`Failure` carries an [`AppError`](../../lib/utils/error.dart) with a `Feature.Reason` code, a description and an
`ErrorType`. Services throw [`ApiException`](../../lib/data/services/api_exception.dart) for transport problems;
the repository converts it, so nothing above `data/` sees an exception. See
[Error Handling](../architecture/cross-cutting/error-handling.md).

## Consequences
**Good.** Sealed classes make callers handle both cases. Error codes are stable and assertable in tests.
**Costly.** More ceremony than `throw`; a thrown exception from a bug still escapes and must be caught at the app edge.
**Alternatives rejected.** Exceptions everywhere (hidden control flow); a package such as `fpdart` (a dependency for ~25 lines).

## When to revisit
If Dart gains a standard result type.
