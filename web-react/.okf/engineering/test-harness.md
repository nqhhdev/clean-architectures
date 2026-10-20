---
type: Convention
title: "Test harness"
description: "The four test tiers as built: Vitest unit and component tests, MSW adapter tests, fakes per port, renderWithProviders, and the Playwright smoke test on the mock build."
resource: vitest.config.ts
tags: [convention, testing, vitest, msw, playwright]
status: draft
---
# Test harness

Tiers and the 80% gate are decided in [ADR 0007](../adr/0007-test-tiers-and-coverage.md); the harness in
[ADR 0017](../adr/0017-test-harness.md).

| Tier | Where | Tools | Rule |
|---|---|---|---|
| Unit | `src/**/*.test.ts` next to the code | Vitest, jsdom | Pure functions and small modules: `createEmail`, `errorKey`, `shouldRetryQuery`, `redact` |
| Component | `*.test.tsx` next to the component | Testing Library, `renderWithProviders`, `renderApp` | Pass a fake port; never mock `fetch` or an adapter module (K23) |
| Adapter | `src/adapters/**/*.test.ts` | MSW (`setupServer`, `// @vitest-environment node`) | Real HTTP client against generated handlers; no fakes (K23) |
| Layer rules | `src/test/boundaries.test.ts`, `src/test/security-lint.test.ts` | ESLint API on fixtures | One fixture per forbidden edge |
| e2e smoke | `e2e/*.spec.ts` | Playwright, chromium | Runs the built mock bundle, not the dev server |

## Helpers in `src/test/`
* `renderWithProviders(ui, { services, path })`: one component as the root route of a memory-history router, under real
  `StrictMode`, i18n, `QueryClient` (retries off) and `ServicesContext`.
* `renderApp({ services, path })`: the real route tree, guard and error components.
* `createFakeServices(overrides)` and one typed fake per port (`createFakeEmails`, `createFakeSession`,
  `createFakeLogger`, `createFakeCrashReporter`). `services` replaces whole ports; each fake takes partial overrides.
* `setup.ts`: jest-dom matchers, `asyncUtilTimeout` of 3 s, a no-op `window.scrollTo`.
* Helpers are importable by tests and by each other, never by production code.

## Coverage and scope
`pnpm test:coverage` fails below 80% line coverage. Excluded: `main.tsx`, `main.mock.tsx`, generated code, `src/test/**`,
`src/locales/**` and test files. Vitest runs only `src/**` and `scripts/**` tests, so Playwright specs never run under it.

## Mock mode and e2e
`vite --mode mock` (`pnpm dev:mock`) and `vite build --mode mock` (`pnpm build:mock`) swap the entry in `index.html`
to `src/main.mock.tsx`, serve `public-mock/` (the MSW worker) and build into `dist-mock/`. The production `dist/` never
contains MSW (K24). `pnpm e2e` regenerates the client, builds the mock bundle, runs
`scripts/check-bundle.mjs --expect-mock dist-mock`, then Playwright against `vite preview --mode mock` on port 4173.
`pnpm e2e` is not part of `pnpm check`; CI runs it as its own job ([ADR 0018](../adr/0018-ci-and-runtime-delivery.md)).

Procedures: [Run the app](../workflows/engineering/run-the-app.md), [Run e2e tests](../workflows/engineering/run-e2e-tests.md).
