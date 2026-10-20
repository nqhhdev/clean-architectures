---
type: ADR
title: "ADR 0006: Strict TypeScript, ESLint flat config and Prettier; generated code is ignored"
description: "Strict compiler options and type-checked lint gate every change; generated files are git-ignored and left out of lint, coverage, docs and okf.py."
tags: [adr, typescript, lint, tooling]
status: stable
---
# ADR 0006: Strict TypeScript, ESLint flat config and Prettier; generated code is ignored

**Status:** Accepted - 2026-10-19. See also [ADR 0016](0016-compiler-flags-alias-and-lint-rules.md) for the alias and the extra lint rules.

## Context
A starter is copied by many projects, so the defaults should be the strict ones.

## Decision
`tsconfig.json` is strict, with `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes` and `verbatimModuleSyntax`.
ESLint uses the flat config with `typescript-eslint` `strictTypeChecked` and `stylisticTypeChecked`; Prettier formats.
Generated code (the API client) is git-ignored, rebuilt by a script, and left out of lint, coverage, docs and `okf.py`.
Format check (`prettier --check`), lint, typecheck, tests and build must pass before a change is complete
(`pnpm check` runs all of them plus `okf.py --check`). TypeScript is pinned to 6.0.3.

## Consequences
**Good.** Early failures; one style.
**Costly.** **Risk:** `typescript-eslint` 8.71.2 declares a peer range that excludes TypeScript 7, so the stack stays on 6.0.3 (peer range `<6.1.0`) and
lags the latest compiler. Strict type-checked lint is slower and noisier on legacy code.
**Alternatives rejected.** TypeScript 7 with type-aware lint disabled: loses the rules this stack relies on.

## When to revisit
When `typescript-eslint` supports TypeScript 7: bump, drop the pin and update the backlog item.
