---
type: ADR
title: "ADR 0016: Compiler flags, the @/ alias and a fixed lint rule set"
description: "The @/ alias, the contents of pnpm check, and the extra lint rules and plugins, each added in the step where it has code to check."
tags: [adr, tooling, lint, typescript]
status: stable
---
# ADR 0016: Compiler flags, the @/ alias and a fixed lint rule set

**Status:** Accepted - 2026-10-19. Extends [ADR 0006](0006-strict-typescript-and-lint.md); ADR 0006 stays in force.

## Context
ADR 0006 sets strict TypeScript and type-checked lint. The layer rules of
[ADR 0010](0010-hexagonal-layers-boundaries-and-services.md) and the conventions of the other ADRs need a few more
rules, a path alias, and a clear definition of what `pnpm check` runs.

## Decision
* `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes` and `verbatimModuleSyntax` are already set in `tsconfig.json`.
* The `@/` alias maps to `src/` in `tsconfig.json` (`paths`) and `vite.config.ts` (`resolve.alias`); `vitest.config.ts`
  merges the Vite config and inherits it.
* `pnpm check` runs `generate`, `format:check`, `lint`, `typecheck`, `test:coverage`, `build`, `check:bundle`,
  `scan:secrets` and `okf` (the last two added in steps 9 and 10); the Playwright smoke test is the separate `pnpm e2e`.
* Lint rules: named exports only; no `enum`; no `as unknown as`; no inline `style` prop; `eqeqeq`; `no-console` with
  `warn` and `error` allowed; `jsx-a11y` strict; `react-hooks`; `@tanstack/eslint-plugin-query`;
  `@vitest/eslint-plugin`; plus the boundaries matrix. Where no plugin rule exists, `no-restricted-syntax` is used.
* Each plugin is added in the step where it has code to lint (boundaries in step 3, the others as their code appears),
  so no step ships rules with nothing to check.
* Exceptions are scoped by file glob in `eslint.config.js`. An `eslint-disable` needs a comment naming the reason.
  Default exports are allowed only where a tool requires them (`*.config.ts`, and any file TanStack Router needs if
  file-based routes are ever used).
* `eslint-plugin-boundaries` 7.2.0 is **verified** on ESLint 10.13 and TypeScript 6.0.3 (2026-10-19, step 3: the
  allow-matrix and its self-test run green). **Step 7 (2026-10-20):** `@tanstack/eslint-plugin-query` 5.104.4 (peer `eslint ^10`) and `@vitest/eslint-plugin` 1.6.27 (peer `eslint >=8.57`) are installed and `pnpm lint` is green on ESLint 10.13; their recommended configs are on (the Vitest rules for `*.test.*` only). `eslint-plugin-jsx-a11y` 6.10.2 declares peer `eslint ^3 || ... || ^9`, so it is **dropped** and its rule set is recorded in the backlog ([ESLint 10 plugin gap](../backlog/jsx-a11y-eslint-10.md)) (decided by builder, awaiting owner review). `eslint-import-resolver-typescript` replaces `eslint-import-resolver-alias` for `eslint-plugin-boundaries`: the alias resolver throws on `exports` maps with a `node: null` condition (`msw/browser`), the TypeScript one reads `tsconfig` paths and `exports` (decided by builder, awaiting owner review). If a plugin does not
  support them, ESLint is not pinned back: a failing `eslint-plugin-boundaries` is replaced by `no-restricted-imports`
  zone patterns that encode the same matrix, and any other plugin is dropped and its rule recorded in the backlog.
* `@tanstack/react-query` 5.104.5 and `@tanstack/react-router` 1.170.45 (exact pins, step 5) install and typecheck on React 19, TypeScript 6.0.3 and ESLint 10.13; `pnpm lint` is green. `@typescript-eslint/only-throw-error` allows the router's `Redirect` (from `@tanstack/router-core`) so guards can `throw redirect(...)` (decided by builder, awaiting owner review).
* Step 10 adds `eslint.security.config.js` (bans `localStorage`, `sessionStorage`, `document.cookie` writes and `dangerouslySetInnerHTML` through `no-restricted-syntax`, with a self-test) next to the boundaries config, and scripts under `scripts/` are linted without type information ([ADR 0019](0019-client-side-security-baseline.md)).
* `pnpm-workspace.yaml` sets `minimumReleaseAgeExclude` for `@tanstack/react-query@5.104.5` and `@tanstack/query-core@5.104.5` (decided by builder, awaiting owner review). pnpm holds back versions younger than its minimum release age (supply-chain rule S6); the 5.104.5 pair was published on 2026-10-19 at about 17:00 UTC, hours before the step-5 pin, and the exact pin is what the lockfile verifies, so the exclusion lets that one pair install. It is not permanent: remove both entries once the pair is older than the window (pnpm's default window is not verified here) or when a newer patch replaces the pin, and confirm with `pnpm install` from a clean cache. Checked on 2026-10-19 at 19:07 UTC (about two hours after publication): too young to remove.
* `pnpm-workspace.yaml` sets `allowBuilds: unrs-resolver: false`: the resolver used by `eslint-plugin-boundaries` runs a postinstall only to fetch a WASM fallback, its native binary comes as an optional dependency, and dependency build scripts stay denied by default (S6).

## Consequences
**Good.** Conventions that were prose become failing lint; no dead rules ship early.
**Costly.** Several new dev dependencies to keep current; the fallback for boundaries is coarser than the plugin.
**Alternatives rejected.** Pinning ESLint to suit a plugin: it would hold back the gate for everything else.
Adding every plugin in step 2: rules with nothing to lint.

## When to revisit
When a plugin is dropped, or when `typescript-eslint` supports TypeScript 7 (see the
[upgrade task](../backlog/typescript-7-upgrade.md)).
