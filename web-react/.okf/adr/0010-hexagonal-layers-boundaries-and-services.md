---
type: ADR
title: "ADR 0010: Hexagonal layers with a lint-enforced allow-matrix and injected services; one OKF bundle per stack"
description: "src/ is split into domain, application, adapters, ds, features and app; an allow-matrix enforced by eslint-plugin-boundaries fixes who may import whom, and services reach features through one context."
tags: [adr, architecture, layers, boundaries, di, okf]
status: stable
---
# ADR 0010: Hexagonal layers with a lint-enforced allow-matrix and injected services; one OKF bundle per stack

**Status:** Accepted - 2026-10-19. Supersedes [ADR 0001](0001-layers-and-boundaries.md) in full.

## Context
A React SPA has no framework-imposed structure, so layer rules that are not written down and checked drift. ADR 0001
chose `ui / domain / data / config / utils`; that set has no place for ports, for a design system, or for the two entry
points (real and mock) that tests and local development need. The knowledge about this stack still does not apply to
the other stacks in the monorepo.

## Decision
**Layers.** `src/` has these folders:

| Folder | Holds | Must not import (npm) |
|---|---|---|
| `domain/` | Pure types and functions: entities, value objects, `Result<T, E>`, constructors, rules | React, TanStack, zod, i18next, fetch clients |
| `application/` | Ports (one interface per resource), `AppError`, `QueryError`, the `Services` type, `Logger` and `CrashReporter` ports | the same list |
| `adapters/` | Port implementations: `api/` (orval client, zod parsing, mappers, HTTP client), `auth/`, `live/`, `telemetry/` | - (may use fetch, zod, orval output) |
| `ds/` | Design system components, CSS Modules, tokens as CSS variables ([ADR 0011](0011-design-system-and-styling.md)) | everything but React |
| `features/<name>/` | Screens, feature components, `queries.ts` | adapters |
| `app/` | Providers, router, query client, theme and i18n set-up, `app/services/` | - |
| `locales/` | Translation JSON ([ADR 0015](0015-i18n-keys-from-en-json.md)); data, not code | everything |

**Allow-matrix.** Rows import columns. `src/test/**` and `*.test.*` may import everything; `main.tsx` and
`main.mock.tsx` are the `root` file category (composition root): they may import any layer and nothing may import them.

| from \ to | domain | application | adapters | ds | features | app | locales |
|---|---|---|---|---|---|---|---|
| `domain` | self | no | no | no | no | no | no |
| `application` | yes | self | no | no | no | no | no |
| `adapters` | yes | yes | self | no | no | no | no |
| `ds` | no | no | no | self | no | no | no |
| `features` | yes | yes | no | yes | own feature only | `app/services` only | no |
| `app` | yes | yes | yes | yes | yes | self | yes |

The single exception is `features -> app/services`; it is modelled as its own element so it stays one matrix cell.
A feature never imports a sibling feature: shared code moves to `domain/` or `ds/`. A new top-level folder under `src/`
needs a matrix row before it lands.

**Composition roots.** `main.tsx` builds the real adapters; `main.mock.tsx` builds the same `Services` with MSW behind
the same API adapter. Both call one shared `app/` bootstrap so the two cannot drift. Only these two files, and
adapter tests, call an adapter factory.

**Services.** `application/` defines one port per resource, named for the resource (`EmailsPort`, `SessionService`),
and `type Services = { emails: EmailsPort; session: SessionService; ... }`. Adapters are factory functions
(`createEmailsApi(http): EmailsPort`), with no hidden-state classes and no singletons at module load. The React
`ServicesContext` and `useServices()` live in `app/services/` (the one place React and the `Services` type meet);
app-wide hooks such as `useSession()` live there too. A feature gets a service only through `useServices()`. Router
loaders and `queryOptions` factories receive services explicitly from router context
([ADR 0013](0013-data-loading-and-routing.md)), never by calling a hook. A repository plus use-case pair is added only
when logic needs it.

**Enforcement.** `eslint-plugin-boundaries` encodes the matrix in `eslint.config.js` from step 3 of the
bootstrap plan (done). Because lint resolves static
imports only, a rule self-test keeps one fixture per forbidden edge, including the `@/` alias, `import type` and dynamic
`import()`. See [constraints](../engineering/constraints.md) K1-K9.

**Bundle.** Knowledge for this stack stays in `web-react/.okf/`, an Open Knowledge Format v0.2 bundle in the same
directory layout as the other stacks, checked by [`tools/okf.py`](../tools/okf.py) locally and in CI.

**Terminology.** Older ADRs say `data/`, repositories and `config/`. Read `data/` as `adapters/api/`, repositories as
ports, and the env parsing of [ADR 0005](0005-zod-at-the-data-boundary.md) as living in `app/` ([ADR 0018](0018-ci-and-runtime-delivery.md)).

## Consequences
**Good.** Swapping a data source touches `adapters/` and the composition roots; tests pass fakes through the same
`Services` type the app uses; a violated direction fails lint rather than review.
**Costly.** Six layers plus the `app/services` exception are more to learn than five; the lint cannot see dynamic
imports built from strings; many small knowledge files rot unless updated with the code. The `eslint-plugin-boundaries`
support for ESLint 10 is verified (2026-10-19: `eslint-plugin-boundaries` 7.2.0 on ESLint 10.13, rules and self-test running; see [ADR 0016](0016-compiler-flags-alias-and-lint-rules.md)).
**Alternatives rejected.** Feature-first folders with a full layer triple per feature: turns the layer rule into a
per-feature rule. A `src/di/` folder importable by features and `app/`: a second place for wiring. Services through
router context only, with props and loaders for features: awkward for deep components. One repository and use case
per operation: ceremony without logic to justify it. One shared bundle at the monorepo root: stacks differ too much.

## When to revisit
When `src/` outgrows one package (split into workspace packages), when a second stack needs to reuse concepts (extract
rather than copy), or when the `app/services` exception grows beyond services and session.
