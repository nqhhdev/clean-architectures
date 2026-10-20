---
type: ADR
title: "ADR 0017: Test harness with real providers, typed fakes per port and MSW in mock mode"
description: "renderWithProviders wires real providers around fake ports; adapter tests use MSW; Playwright runs against a mock-mode build served by vite preview."
tags: [adr, testing, msw, playwright]
status: stable
---
# ADR 0017: Test harness with real providers, typed fakes per port and MSW in mock mode

**Status:** Accepted - 2026-10-19. Extends [ADR 0007](0007-test-tiers-and-coverage.md); the tiers and the coverage gate stay as they are.

## Context
ADR 0007 names four tiers and hand-written fakes. With the ports and composition roots of
[ADR 0010](0010-hexagonal-layers-boundaries-and-services.md) the harness can be made concrete, and the e2e target
"built app with MSW" needs a definition.

## Decision
* `renderWithProviders(ui, overrides)` in `src/test/` uses a real `QueryClient` (retries off), a real router with memory
  history, real i18n, `StrictMode`, and a real `ServicesContext` whose value is the default fakes merged with
  `overrides` (partial per port).
* One typed, hand-written fake per port (`createFakeEmails(overrides?)`); no mock framework.
* Component tests never mock `fetch` or an adapter module; they pass a fake port. Adapter tests never use fakes; they
  use MSW.
* MSW uses orval-generated mock handlers plus a hand-written seed. `dev:mock` runs Vite in mock mode with
  `main.mock.tsx`.
* Playwright runs against `vite build --mode mock` served by `vite preview`, so it tests a built bundle, not the dev
  server.
* Async timeout is 3 s.
* `main.mock.tsx` and MSW must not reach the production bundle: the quality step greps the production `dist/` for `msw`
  (or builds mock mode into a separate output directory; built: separate directory plus the grep).

## Consequences
**Good.** Tests exercise the same wiring as the app; fakes are type-checked against the ports; e2e covers a real build.
**Costly.** MSW handlers need upkeep when the contract changes; the mock build is a second build in CI.
**Alternatives rejected.** Playwright on the dev server: tests the dev bundle, not what ships. Module mocks of adapters:
pin implementation, not behaviour.

## When to revisit
When the real .NET API is reachable from CI, or if the mock build time outweighs its value.

## Built in step 9
Decided by builder, awaiting owner review.
* Mock mode selects its entry with a Vite plugin in `vite.config.ts` that rewrites the module script of `index.html` from `/src/main.tsx` to `/src/main.mock.tsx` (`transformIndexHtml`, `order: 'pre'`, because the build reads the entry before default-order hooks). One HTML file, no alias, and the production HTML never names the mock entry.
* Mock mode sets `publicDir: 'public-mock'` and `outDir: 'dist-mock'`, so the production `dist/` is built from a different directory and never contains MSW. This is the second option of the decision above; the grep is `pnpm check:bundle` (`scripts/check-bundle.mjs`), which also fails on source maps, and `--expect-mock dist-mock` fails if a mock build lacks the worker or `setupWorker`.
* `pnpm dev:mock` is `vite --mode mock`; `pnpm build:mock` is `vite build --mode mock`.
* The Playwright smoke test (`e2e/smoke.spec.ts`, chromium only) starts `vite preview --mode mock` and runs through `pnpm e2e` (generate, mock build, `--expect-mock` check, `playwright test`). `pnpm e2e:install` downloads chromium. `vitest.config.ts` includes only `src/**` and `scripts/**` tests, so Playwright specs never run under Vitest.
* **e2e is not part of `pnpm check`.** It needs a browser download and the mock build, and plan decision 7 makes it a separate CI job required on pull requests to `main`; `pnpm check` keeps the bundle check, which needs no browser.

Built in step 5 (decided by builder, awaiting owner review): `renderWithProviders(ui, { services, path })` renders one component as the root route of a memory-history router; `renderApp({ services, path })` renders the real route tree. `services` replaces whole ports (`Partial<Services>`); each fake takes partial overrides at construction (`createFakeSession(overrides, initial)`). The async timeout is `asyncUtilTimeout: 3000` in `src/test/setup.ts`. Helpers in `src/test/` are importable by tests and by each other, never by production code.
