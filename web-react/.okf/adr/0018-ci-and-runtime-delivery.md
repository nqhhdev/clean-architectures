---
type: ADR
title: "ADR 0018: One CI workflow runs pnpm check; deploy reads /env.js at runtime"
description: "One workflow with a gate job runs install, audit and pnpm check; the deployed image serves static files, a runtime /env.js and a CSP generated at start."
tags: [adr, ci, deploy, security]
status: stable
---
# ADR 0018: One CI workflow runs pnpm check; deploy reads /env.js at runtime

**Status:** Accepted - 2026-10-19. Extends [ADR 0007](0007-test-tiers-and-coverage.md) (the e2e job and coverage gate).

## Context
The same gate should run for pushes, pull requests and a merge queue. A required check behind a path filter stays
pending for pull requests that touch only other stacks. Separately, one built SPA should run in every environment, and
public configuration must not be baked in at build time.

## Decision
**CI** (built in steps 2 and 12 of the bootstrap).
* One workflow, `.github/workflows/web-react.yml`, starts itself on push to `main`, pull request and `merge_group`
  (no `workflow_call`, by choice; see the note of 2026-10-20 below). It runs `pnpm install --frozen-lockfile`, `pnpm audit --prod --audit-level=high` and `pnpm check` (which includes the coverage
  threshold and `okf.py --check`).
* The workflow starts on every event. A first job detects whether `web-react/**` or the workflow file changed; the
  heavy job is skipped when not. A `gate` job always runs, needs both, and is the only required status check.
* `actions/setup-node` uses `node-version-file: web-react/.nvmrc`; pnpm comes from `pnpm/action-setup`, which reads `packageManager` (Node 25+ ships no corepack).
* `concurrency` cancels in-progress runs, `permissions` is `contents: read`, actions are pinned by commit SHA with the
  version in a comment, there is no `pull_request_target` and no secrets.
* The Playwright job is added in step 12 and is required on pull requests to `main` ([ADR 0007](0007-test-tiers-and-coverage.md)). Its command is `pnpm e2e` (step 9), which stays outside `pnpm check`; `pnpm check` also runs the bundle check and the secret scan ([ADR 0019](0019-client-side-security-baseline.md)).

**Deploy** (step 14, built 2026-10-20; see below).
* The SPA reads runtime config from `/env.js`, served by the container and not baked at build. It is parsed once at
  boot with zod; boot fails fast with a visible error page if it is invalid. `VITE_*` build-time values remain for
  development and mock mode only.
* The image is `nginx-unprivileged`. Its entrypoint writes `env.js` and the nginx config, including the CSP, at start
  from environment variables, so `connect-src` always matches the API URL.
* `env.js` holds public values only ([ADR 0009](0009-cookie-session-and-csrf-owned-by-the-api.md)). It loads before the
  app module, and boot has one failure path, so the app is never half started.
* A realtime `live` port is optional and tracked in the [backlog](../backlog/realtime-live-port.md), not decided here.

## Consequences
**Good.** One definition of "green"; one build for all environments; the CSP cannot drift from the API URL.
**Costly.** A gate job and a change-detection job are more YAML; the `audit` gate can fail unrelated pull requests when
a new high advisory appears; runtime config means a second place (the entrypoint) that knows the variable names.
**Alternatives rejected.** A workflow-level `paths` filter with a required check: pending forever on other stacks. A
non-required check until a merge queue exists: no real gate. Build-time `import.meta.env` in production: one image per
environment.

## When to revisit
When a hosting platform replaces the container, or when the audit gate blocks work often enough to need an allowlist.

## Built in step 12
Decided by builder, awaiting owner review.
* The workflow is `.github/workflows/web-react.yml` and has no `workflow_call` (step 2, by choice): it starts on push to `main`, pull requests and `merge_group` itself.
* Jobs: `changes` -> `check` -> `e2e` -> `gate`. `changes` also outputs `e2e`, true only when `web-react/` or the workflow changed on a pull request whose base is `main`.
* A `docker` job (added 2026-10-20) builds the image and smoke-tests it (`/healthz`, CSP and HSTS headers, non-root user) when `web-react/Dockerfile`, `.dockerignore`, `docker/`, the lockfile or the workflow change; `gate` requires it to be `success` then, and accepts `skipped` otherwise.
* `e2e` needs `check` (it runs "after build", and a failing gate does not download a browser), installs dependencies, resolves the `@playwright/test` version, caches `~/.cache/ms-playwright` under `playwright-<os>-<version>`, installs chromium with system dependencies on a miss and only the system dependencies on a hit, then runs `pnpm e2e`. Traces from `test-results/` are uploaded on failure.
* `gate` needs all three and stays the only required check: when `e2e` is required it must be `success`; otherwise `success` or `skipped`. Pushes to `main` and merge-queue runs skip `e2e`.
* Dependabot has an `npm` entry for `/web-react` (weekly, grouped minor and patch, major TypeScript ignored while pinned, [ADR 0006](0006-strict-typescript-and-lint.md)).
* `.githooks/pre-commit` formats staged `web-react/` files with Prettier and runs the `.okf` check when `web-react/.okf/` is staged; each gate runs only for its own stack's staged files.

## Note 2026-10-20: no reusable workflow
The Decision text first said the workflow was reusable (`workflow_call`). It is not, by choice: nothing calls it from
another workflow, and the repository keeps one workflow file per stack that triggers itself. The Decision above now
describes the real file; the shape of the gate (`changes`, `check`, `e2e`, `gate`) is unchanged. Actions are pinned by
commit SHA with a version comment, like the Flutter workflow, instead of by major version.

## Built in step 14
Decided by builder, awaiting owner review.
* `index.html` loads `/env.js` as a classic script, which runs before the deferred module. `public/env.js` is an empty placeholder (`window.__ENV__ = {}`) so the dev server and a plain static host serve valid JavaScript; the entrypoint replaces it. Mock mode drops the tag (the mock build has no runtime config).
* `app/runtime-config.ts` parses `window.__ENV__` with zod: `API_URL` is a same-origin path (`/api`) or an absolute URL; http is allowed only for `localhost`, `127.0.0.1`, `[::1]` and `*.localhost`; no credentials, query or fragment; trailing slashes are dropped. `main.tsx` is the only caller and has one failure path: `renderBootError` (plain DOM, text only) and no app. In development only, a missing `API_URL` falls back to `VITE_API_URL` or `/api`; a production build never falls back. The constant `/api` is gone from `main.tsx`; `main.mock.tsx` keeps `/api` because MSW answers it.
* `Dockerfile`: a Node stage runs `pnpm build`, the final stage is `nginxinc/nginx-unprivileged` (uid 101, port 8080) and copies `dist/` plus `docker/entrypoint.sh`. The build bakes no configuration.
* `docker/entrypoint.sh` validates `API_URL` with the same rule (and rejects characters that could break out of a JS string, the CSP or the nginx config), writes `env.js` and `security-headers.conf` under `/tmp/runtime`, writes the nginx server config, then starts nginx. A bad value exits non-zero, so the container never serves a half configured app.
* Headers: CSP (`default-src 'self'`, `script-src 'self'`, `style-src 'self'`, `img-src 'self' data:`, `font-src 'self'`, `connect-src 'self'` plus the API origin, `object-src 'none'`, `base-uri 'self'`, `form-action 'self'`, `frame-ancestors 'none'`), `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Permissions-Policy`, `Cross-Origin-Opener-Policy`, `Strict-Transport-Security`. Every location that sets its own `add_header` includes the headers file again, because nginx drops inherited headers otherwise. `env.js` is `no-store`, `/assets/` is immutable, everything else is `no-cache` with an `index.html` fallback; `/healthz` answers 200.
* The only variable is `API_URL`; the entrypoint is the second place that knows its name.

## Note 2026-10-20: base images pinned by digest
Approved by the owner. Both base images (`node:26-alpine` build stage, `nginxinc/nginx-unprivileged:1.29-alpine` runtime) are pinned as `tag@sha256:<digest>`: the tag is for readers, the digest is what is pulled. Updates arrive as Dependabot digest bumps (the `docker` entry for `/web-react` in `.github/dependabot.yml`, weekly), reviewed like any other dependency pull request.

Verified 2026-10-20 on a local build: the image builds and runs as uid 101; `/healthz` answers 200 and the Docker health check reports healthy; the entrypoint writes `/etc/nginx/conf.d/default.conf`; every response carries the CSP (no `unsafe-inline`, no `unsafe-eval`) and the other security headers; hashed assets are immutable and `index.html` is `no-cache`; Chromium loading the app under the generated CSP reports 0 violations (zod runs jitless, `src/app/zod-config.ts`).

## Note 2026-10-20: deploy target and owner decisions
The template stays platform-agnostic: it ships a container and expects TLS to be terminated by a proxy or platform in front (which may also add brotli); the consuming repository picks the platform. Accepted as built: the CSP and header policy (HSTS from the container, no `unsafe-inline`), e2e required on pull requests to `main` only, and actions pinned by commit SHA (inputs are checked on the first GitHub run). The `check` job also runs a gitleaks history scan ([ADR 0019](0019-client-side-security-baseline.md)).

## Unverified
The workflow has not run on GitHub: the YAML is parsed locally only, so change detection, the cache key, the `gate` logic and the inputs of the SHA-pinned actions are untested. The image, its headers and the CSP were verified locally on 2026-10-20 (see the note above), not yet on a hosting platform.
