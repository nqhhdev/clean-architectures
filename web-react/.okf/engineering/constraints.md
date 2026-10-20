---
type: Constraint
title: "Architecture constraints"
description: "Numbered rules K1-K35 for layers, errors, data loading, session, i18n, tooling, tests, delivery and security, each tied to its ADR."
resource: eslint.config.js
tags: [constraint, architecture, lint]
status: draft
---
# Architecture constraints

Numbers are stable: cite `K<n>` in reviews and tests. **Enforced today:** K24, K31, K34 and K35 by the scripts and lint named in each rule, and K1, K6, K19 (the `ds/` half: no i18n import), K20 and K30 by the
`eslint-plugin-boundaries` allow-matrix (`eslint.boundaries.config.js`) and its self-test
(`src/test/boundaries.test.ts`). K25 and K26 are implemented in the CI workflow. K14, K15 and K18 are implemented and unit-tested (`app/query-client.ts`, the `beforeLoad` guard in `app/router.tsx`, `app/session-bootstrap.ts`), not lint-enforced. K5 is enforced by configuration (git-ignore and lint, coverage, prettier and `okf.py`
exclusions), not by a check. K27 to K29 are implemented and unit-tested (`app/runtime-config.ts`, `docker/entrypoint.sh`); K28's image is built from the `Dockerfile` but the build was not run in the sandbox. The rest are
conventions without a tool. Where a rule is "review only", no tool checks it.

## Layers and dependency injection ([ADR 0010](../adr/0010-hexagonal-layers-boundaries-and-services.md))
* **K1.** `domain/` and `application/` contain no framework imports (React, TanStack, zod, i18next, router, MSW). `ds/` may import React only (K19, K4 context). *Enforced: boundaries lint + self-test.*
* **K2.** Only `adapters/` performs I/O (fetch, storage, EventSource).
* **K3.** Only `main.tsx` and `main.mock.tsx` choose concrete adapters. *Partly enforced: features cannot import `adapters/`, but `app/` still can; the `root` element may import any layer and nothing may import it.*
* **K4.** Design tokens are declared only in `ds/`. A feature may own `*.module.css` for layout only, and uses colour, typography and spacing only through `ds/` CSS variables ([ADR 0011](../adr/0011-design-system-and-styling.md); review only).
* **K5.** Generated orval output lives inside `adapters/api/`, is git-ignored and is excluded from lint, coverage, docs and `okf.py` ([ADR 0006](../adr/0006-strict-typescript-and-lint.md)). *Enforced by configuration (step 4), not by a check.*
* **K6.** The allow-matrix is the contract. The rule self-test has one fixture per forbidden edge, including the `@/` alias, `import type` and dynamic `import()`. *Enforced: boundaries lint + self-test.*
* **K7.** A new top-level folder under `src/` needs a matrix row before it lands.
* **K8.** One port per resource, named for the resource (`EmailsPort`), not per use case.
* **K9.** Nothing outside the composition roots calls an adapter factory (adapter tests excepted).
* **K30.** No feature imports another feature; shared code goes to `domain/` or `ds/`. The only `app/` import a feature may make is `app/services`. *Enforced: boundaries lint + self-test.*

## Errors ([ADR 0012](../adr/0012-result-and-app-error.md))
* **K10.** `fetch` and `JSON.parse` appear only in `adapters/`, each wrapped so the port returns a `Result`.
* **K11.** `queries.ts` is the one place a `Result` is unwrapped for TanStack Query: `Err` becomes a thrown `QueryError` carrying the `AppError`.
* **K12.** `Result<T, E>` lives in `domain/`; `AppError` lives in `application/`.

## Data loading and routing ([ADR 0013](../adr/0013-data-loading-and-routing.md))
* **K13.** Query keys are built from per-feature constants; no inline key arrays in components.
* **K14.** Queries do not retry `refused`, `unauthorized` or `invalid` errors.
* **K15.** Auth guards live in `beforeLoad`, never in component effects.
* **K16.** Loaders read services from router context, never from a hook.

## Session ([ADR 0014](../adr/0014-session-and-single-401-handler.md))
* **K17.** No `status === 401` check outside the HTTP client. *Implemented: `createHttpClient` calls `onUnauthorized` once per 401 and `main.tsx` wires it to `session.expire()`; tested in `adapters/api/http-client.test.ts` and `app/session-expiry.test.tsx`. Review only for the ban itself.*
* **K18.** Anything that starts work on mount (session, live connection) is idempotent under double start.

## i18n ([ADR 0015](../adr/0015-i18n-keys-from-en-json.md))
* **K19.** User-visible strings in `features/` come from keys; `ds/` takes already-translated props.
* **K20.** Locale JSON lives in `src/locales/` and is imported only by `app/` and tests. *Enforced: boundaries lint + self-test.*

## Tooling ([ADR 0016](../adr/0016-compiler-flags-alias-and-lint-rules.md))
* **K21.** Rule exceptions are scoped by file glob in `eslint.config.js`; an `eslint-disable` carries a comment naming the reason.
* **K22.** Default exports are allowed only where a tool requires them (`*.config.ts`, and files a file-based router would need).

## Tests ([ADR 0017](../adr/0017-test-harness.md))
* **K23.** Component tests never mock `fetch` or an adapter module; they pass a fake port. Adapter tests never use fakes; they use MSW.
* **K24.** `main.mock.tsx` and MSW do not appear in the production bundle. *Enforced: mock mode builds into `dist-mock/` and `pnpm check:bundle` (in `pnpm check`) scans `dist/`; `--expect-mock` proves the scan can find them.*

## CI and delivery ([ADR 0018](../adr/0018-ci-and-runtime-delivery.md))
* **K25.** Workflow actions are pinned by commit SHA with the version in a comment; no `pull_request_target`; no secrets. *Implemented in `.github/workflows/web-react.yml`; review only.*
* **K26.** The only required status check is the always-running `gate` job, so path-filtered runs never leave a pull request pending. *Implemented: `gate` needs `changes`, `check` and `e2e`; the e2e job is required on pull requests to `main` ([ADR 0007](../adr/0007-test-tiers-and-coverage.md)). The branch protection setting itself lives on GitHub.*
* **K27.** `env.js` holds public values only. *Review only: the entrypoint writes `API_URL` and nothing else.*
* **K28.** The CSP is generated at container start from the same environment as `env.js`. *Implemented: `docker/entrypoint.sh` derives `connect-src` from `API_URL`; header generation is tested in `docker/entrypoint.test.mjs`.*
* **K29.** `env.js` loads before the app module and boot has one failure path. *Implemented: `index.html` loads the classic script, `main.tsx` parses it once with `readRuntimeConfig` and calls `renderBootError` on failure; the https rule is tested in `app/runtime-config.test.ts`, and the entrypoint rejects the same values.*

## Security ([ADR 0019](../adr/0019-client-side-security-baseline.md))
* **K31.** No `localStorage`, `sessionStorage` or script-written cookie; no `dangerouslySetInnerHTML` without a sanitizer decision. *Enforced: lint (`eslint.security.config.js`) + self-test.*
* **K32.** Every API request sends `credentials: 'include'`; non-GET requests get the CSRF headers from one hook. *Implemented and unit-tested in `createHttpClient` and `createCsrfHeaders`.*
* **K33.** `Logger` output is redacted; the API client logs method, path, status and duration only. *Implemented and unit-tested (`redact`, `createConsoleLogger`, `createHttpClient`).*
* **K34.** No secret pattern in tracked files or `dist/`. *Enforced: `pnpm scan:secrets` in `pnpm check`.*
* **K35.** The production bundle has no source maps. *Enforced: `build.sourcemap: false` and `pnpm check:bundle`.*
