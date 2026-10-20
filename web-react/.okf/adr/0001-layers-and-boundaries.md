---
type: ADR
title: "ADR 0001: Layers ui, domain, data, config and utils, enforced by lint; one OKF bundle per stack"
description: "Organise src/ by architectural role, enforce the dependency directions with eslint-plugin-boundaries, and keep this stack's knowledge in its own .okf/ bundle."
tags: [adr, architecture, layers, okf]
status: deprecated
---
# ADR 0001: Layers ui, domain, data, config and utils, enforced by lint; one OKF bundle per stack

**Status:** Superseded by ADR 0010 (`0010-hexagonal-layers-boundaries-and-services.md`) - 2026-10-19. Originally accepted 2026-10-19; mirrors the Flutter stack's layering and its per-stack knowledge bundle.

## Context
The monorepo holds one self-contained stack per folder. A React SPA has no framework-imposed structure, so layer rules
that are not written down and checked drift. The knowledge about this stack (layers, tools, patterns) does not apply
to the other stacks.

## Decision
`src/` has `ui`, `domain`, `data`, `config` and `utils`. Dependencies point `ui -> domain <- data`; `utils` imports
nothing from the app; only `config` and the entry files (`main.tsx`, `App.tsx`) see concrete `data` classes.
`eslint-plugin-boundaries` enforces these directions in the flat config, and a small architecture test covers what a
lint rule cannot express (file naming, the rules' own self-test). `web-react/.okf/` is an Open Knowledge Format v0.2
bundle in the same directory layout as the other stacks, checked by [`tools/okf.py`](../tools/okf.py) in CI and locally.

## Consequences
**Good.** Swapping a data source touches `data/` and `config/` only; a rule violation fails the build, not a review.
**Costly.** The lint resolves static imports only: dynamic `import()` and path aliases need explicit coverage in the rule
self-test. Many small knowledge files can rot unless updated in the same change as the code.
**Alternatives rejected.** Feature-first folders with a full layer triple per feature: fine at scale, but it turns the
layer rule into a per-feature rule. One shared bundle at the monorepo root: stacks differ too much to share concepts.

## When to revisit
When `src/` outgrows one package (split into workspace packages), or when a second stack needs to reuse concepts
(extract them rather than copying).
