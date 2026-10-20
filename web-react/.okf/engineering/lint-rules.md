---
type: Convention
title: "Lint and compiler rules"
description: "What eslint.config.js, the boundaries and security configs, and tsconfig enforce, how to add an exception, and where each rule is tested."
resource: eslint.config.js
tags: [convention, lint, typescript]
status: draft
---
# Lint and compiler rules

`pnpm lint` runs ESLint 10 with a flat config; `pnpm typecheck` runs `tsc --noEmit` on strict TypeScript 6.0.3
([ADR 0006](../adr/0006-strict-typescript-and-lint.md), [ADR 0016](../adr/0016-compiler-flags-alias-and-lint-rules.md)).
Both are part of `pnpm check`.

| Config | Enforces | Self-test |
|---|---|---|
| `eslint.config.js` | `typescript-eslint` `strictTypeChecked` and `stylisticTypeChecked`; `react-hooks`; `@tanstack/eslint-plugin-query`; `@vitest/eslint-plugin` on `*.test.*`; the router's `redirect` object is allowed in `throw` | - |
| `eslint.boundaries.config.js` | The allow-matrix of [ADR 0010](../adr/0010-hexagonal-layers-boundaries-and-services.md) (K1, K6, K20, K30) and the framework import bans in `domain/`, `application/` and `ds/` | `src/test/boundaries.test.ts`, one fixture per edge in `src/test/boundary-fixtures/` |
| `eslint.security.config.js` | No `localStorage` or `sessionStorage`, no script-written cookie, no `dangerouslySetInnerHTML` (K31) | `src/test/security-lint.test.ts` |

* `jsx-a11y` is not installed: it does not support ESLint 10 ([backlog](../backlog/jsx-a11y-eslint-10.md)).
* The `@/` alias maps to `src/` in `tsconfig.json`, `vite.config.ts` and (inherited) `vitest.config.ts`. The boundaries
  rule resolves it through `eslint-import-resolver-typescript`.
* Generated code in `src/adapters/api/generated/`, `dist/`, `dist-mock/` and `coverage/` is ignored by lint and Prettier.
* Formatting is Prettier (`pnpm format` writes, `pnpm format:check` checks). `.okf/` is not formatted.
* Exceptions are scoped by file glob in `eslint.config.js`; an inline `eslint-disable` names its reason (K21).
* A new top-level folder under `src/` needs an element and a matrix row first (K7), and a fixture per forbidden edge.

Rules: [Architecture constraints](constraints.md). Test conventions: [Test harness](test-harness.md).
