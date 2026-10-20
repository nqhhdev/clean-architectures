---
type: ADR
title: "ADR 0012: Adapters never throw for expected failures; Result is generic and AppError is a closed union"
description: "Ports return Promise<Result<T, AppError>> with four error kinds; queries.ts is the one place an Err is turned into a thrown QueryError for TanStack Query."
tags: [adr, errors, result, app-error]
status: stable
---
# ADR 0012: Adapters never throw for expected failures; Result is generic and AppError is a closed union

**Status:** Accepted - 2026-10-19. Supersedes [ADR 0002](0002-result-over-exceptions.md).

## Context
Failures such as validation errors, 4xx responses or a lost network are expected outcomes and callers should be forced
to handle them. The layers of [ADR 0010](0010-hexagonal-layers-boundaries-and-services.md) also need a place for the
error type that is neither transport-specific nor tied to a framework.

## Decision
* `Result<T, E>` is `Ok` or `Err`, generic, and lives in `domain/`.
* `AppError` lives in `application/` (it is the port contract):

```ts
interface AppError {
  kind: 'refused' | 'unauthorized' | 'network' | 'invalid';
  status?: number;
  code?: string;
}
```

* Ports return `Promise<Result<T, AppError>>`. Adapters map HTTP failures, network failures and zod parse failures to
  `Err(AppError)` and never throw for expected outcomes.
* `kind` mapping: 401 -> `unauthorized`; 408 and 429 -> `network`; any other 4xx (403 included) -> `refused`; fetch
  failure, timeout and 5xx -> `network`; zod or shape failure -> `invalid`. 408 and 429 are transient, so they take the
  retry-friendly kind (decided by orchestrator, awaiting owner review).
* `code` is the API's stable error code when the response carries one. An adapter sets its own code only for `invalid`
  (`malformed_response`, as in [ADR 0005](0005-zod-at-the-data-boundary.md)). One helper turns an `AppError` into a
  translation key ([ADR 0015](0015-i18n-keys-from-en-json.md)).
* Bugs and faults still throw and reach the global error hooks and `errorComponent`s.
* TanStack Query marks an error only when `queryFn` throws, and `@typescript-eslint/only-throw-error` rejects plain
  objects. So `queries.ts` is the one place a `Result` is unwrapped: `Err` becomes a thrown `QueryError extends Error`
  that carries the `AppError` (a pure helper in `application/`). Retry rules read it
  ([ADR 0013](0013-data-loading-and-routing.md)).
* `fetch`, `JSON.parse` and storage calls appear only in `adapters/`, each wrapped so the port returns a `Result`.

## Consequences
**Good.** Failure cases appear in types; the mapping from transport to `kind` is tested once per kind; the principle of
ADR 0002 (no throwing across layers for expected failures) is kept.
**Costly.** Every caller handles both arms; `queries.ts` re-throws, which looks like a contradiction until this ADR is
read; third-party code that throws needs a wrapper at the boundary. Type names change from `Success`/`Failure` and a coded
`AppError` (ADR 0002) to `Ok`/`Err` and a `kind`.
**Alternatives rejected.** Throwing typed errors: invisible in signatures. A library such as neverthrow: one more
dependency for a type of about twenty lines. A fifth kind for 5xx: callers react to 5xx and a lost network the same way.

## When to revisit
If the team decides to lean on TanStack Query's own error channel everywhere and drop `Result` above `adapters/`.
