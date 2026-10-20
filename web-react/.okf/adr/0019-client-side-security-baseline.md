---
type: ADR
title: "ADR 0019: Client-side security baseline S1-S7 with lint, scan and bundle checks"
description: "Web form of rules S1-S7: no secrets, https, cookie session without script-reachable tokens, redacted logs, a bundle without source maps or mock code, audited dependencies, metadata-only request logs."
tags: [adr, security, csrf, logging, bundle]
status: stable
---
# ADR 0019: Client-side security baseline S1-S7 with lint, scan and bundle checks

**Status:** Accepted - 2026-10-20 (decided by builder, awaiting owner review). Builds on [ADR 0009](0009-cookie-session-and-csrf-owned-by-the-api.md) and [ADR 0014](0014-session-and-single-401-handler.md); the CI side is [ADR 0018](0018-ci-and-runtime-delivery.md).

## Context
The bootstrap plan maps the seven security rules of the Flutter stack to the web. ADRs 0009 and 0014 fix the session model; this ADR records how each rule is enforced by code or by a check, so none stays prose.

## Decision
| Rule | Web form | Enforced by |
|---|---|---|
| S1 no secrets | `VITE_*` values and `env.js` are public. | `pnpm scan:secrets` (`scripts/secret-scan.mjs`): key blocks, cloud and Git host tokens, JWTs, bearer literals, hard-coded `password`/`secret`/`api key` assignments, `VITE_` names that promise secrecy; scans git-known files and `dist/`. Runs in `pnpm check` after the build. |
| S2 https | Stg and prod API URLs must be https. | `app/runtime-config.ts` (zod, parsed once at boot) and `docker/entrypoint.sh` (same rule, fails the container start); tested in `runtime-config.test.ts` and `docker/entrypoint.test.mjs`. |
| S3 token storage | The session is the API's httpOnly cookie; no token in `localStorage`, `sessionStorage` or script-written cookies. | Lint (`eslint.security.config.js`, self-test `src/test/security-lint.test.ts`): bans `localStorage`, `sessionStorage` (also via `window[...]`), `document.cookie = ...` and `dangerouslySetInnerHTML`. |
| S4 logs | `Logger` output is redacted. | `createConsoleLogger` runs message and context through `redact`: sensitive key names (token, authorization, cookie, password, secret, csrf, session, api key, credential) are masked at any depth, bearer values and JWTs are removed from strings, errors keep name and message only. Tested. |
| S5 build hardening | No source maps and no mock code in what ships. | `build.sourcemap: false`; `pnpm check:bundle` fails on `.map` files, `sourceMappingURL`, `mockServiceWorker`, `setupWorker`, `main.mock`. CSP and headers are written by the image entrypoint ([ADR 0018](0018-ci-and-runtime-delivery.md)). |
| S6 dependencies | Audit and automated updates. | `pnpm audit --prod --audit-level=high` in CI since step 2; Dependabot in step 12. |
| S7 body logging | The API client logs method, path, status and duration only. | `createHttpClient({ logger })`: path without query string, no headers or bodies. Tested. |

**Session client.** `createHttpClient` sends every request with `credentials: 'include'`; non-GET requests get the headers of one injected `csrfHeaders()` hook (`createCsrfHeaders` copies the API's readable CSRF cookie `XSRF-TOKEN` into `X-XSRF-TOKEN`; names are agreed with the API per project). The client is the single 401 handler: an `unauthorized` response calls the injected `onUnauthorized` once per response; `main.tsx` wires it to `session.expire()`, which is idempotent, so concurrent 401s notify subscribers once and the router guard redirects. `createCookieSession` (`adapters/auth/`) reads the user from `GET /session` and signs out with `DELETE /session`; both were added to `openapi/emails.yaml`, so the contract is the placeholder until the .NET spec replaces it.

**HTML.** Nothing renders HTML, so there is no sanitizer. The lint ban on `dangerouslySetInnerHTML` makes adding the first HTML renderer a deliberate decision: add a sanitizer, record it here, scope the lint exception by file glob.

**Mock-mode isolation.** Mock mode builds into `dist-mock/` with `main.mock.tsx` and `public-mock/`; the production `dist/` never sees them. `scripts/check-bundle.mjs --expect-mock dist-mock` runs before the e2e test so the production check cannot pass by scanning nothing.

Decisions where the plan left room:
* `bootstrap()` treats 401 as signed out and any other failure as a thrown error, so the shell error component shows an outage and a later navigation retries (the memoised start forgets a failure) instead of redirecting to sign-in.
* `signOut()` keeps the user and throws when the API did not sign out (not 401); a sign-out that did not happen must not look done.
* `SessionService` gains `expire()`, as ADR 0014 already described.
* The `session` entry of the router context is dropped: the guard reads the service after the memoised bootstrap, and nothing else read the snapshot from context, so keeping it fresh bought nothing.
* The scan checks files, not git history, and uses patterns rather than entropy; a leak already committed needs a history scan outside this repo's gate.

## Consequences
**Good.** Each rule has a failing check; the 401 path has one owner; a leaked token pattern fails before merge.
**Costly.** Pattern scanning misses unknown formats and can flag samples (tests build sample tokens from parts); the redaction key list needs upkeep; the HTTP client has two more options.
**Alternatives rejected.** An allowlist of storage use: nothing here needs browser storage. Entropy-based secret scanning: noisy on hashes and generated code. Keeping `session` in router context and refreshing it: a second owner of session state.

## When to revisit
When the API or a BFF defines the CSRF header and cookie names, refresh or silent re-authentication, or when something renders user HTML.

## Note 2026-10-20: owner decisions
Accepted by the owner for the template: this baseline and its wording; no HTML sanitizer until something renders HTML (the lint ban stays); the `API_URL` rule (https except local hosts). CSRF names and the `/session` contract are a template placeholder that a consuming repository matches to its backend spec. Besides `pnpm scan:secrets` on the tree, CI runs a gitleaks history scan (pinned CLI with checksum, `web-react/.gitleaks.toml` allowlists the scanner's own test fixtures).

## Unverified
CSRF header and cookie names, and the `/session` paths, are template placeholders until a consuming repository wires its API. Nothing tests the cookie behaviour in a real browser against a real API.
