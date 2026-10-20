# Step 1 review fixes: proposed `.okf` changes (NOT applied)

Nothing under `web-react/.okf` was edited. Apply after review. After applying, run `pnpm okf`.

## 1. Rename `architecture/system-context.md` -> `architecture/context.md`

Run `git mv .okf/architecture/system-context.md .okf/architecture/context.md`, then update links:

| File | Change |
|---|---|
| `.okf/architecture/index.md` | `(system-context.md)` -> `(context.md)` |
| `.okf/index.md` line 9 | `(architecture/system-context.md)` -> `(architecture/context.md)` |
| `.okf/map.md` line 26 | `[architecture/system-context.md](architecture/system-context.md)` -> `[architecture/context.md](architecture/context.md)` |
| `.okf/log.md` line 4 | `(architecture/system-context.md)` -> `(architecture/context.md)` |
| `.okf/backlog/bootstrap-plan.md` ("C4 mapping") | `` `system-context.md` `` -> `` `context.md` `` |

Keep the page `title: "System Context"` (only the filename changes) so link text stays valid.

## 2. New full contents of `architecture/context.md` (L1)

```markdown
---
type: System Context
title: "System Context"
description: "C4 level 1 - the user, the web SPA and the external systems it depends on."
resource: package.json
tags: [c4, context, react]
status: draft
---
# System Context

## The system
A **single-page web app** (React, TypeScript) built as a clean-architecture starter. The business capability is yours
to add; the starter will ship one example slice, Emails, served by the same REST surface as the Flutter stack. An
OpenAPI file for that surface is planned ([ADR 0008](../adr/0008-openapi-contract-as-single-schema-source.md)).

## Who uses it
| Actor | Interaction |
|---|---|
| **End user** | Uses the [web SPA](containers.md) in a browser; signs in with the identity provider |
| **Developer** | Builds on the starter; reads this bundle first |

## External systems
| System | Role | Status |
|---|---|---|
| **.NET API** | Source of truth for emails over HTTPS/JSON | Not in this repo. Contract: [ADR 0008](../adr/0008-openapi-contract-as-single-schema-source.md) |
| **Identity provider** | Authenticates the end user; the API validates the result and issues the session | Placeholder until each project picks one; cookie issuing is the API's job ([ADR 0009](../adr/0009-cookie-session-and-csrf-owned-by-the-api.md)) |

## Relationships
* End user -> Web SPA: uses in a browser.
* End user -> Identity provider: signs in.
* Web SPA -> .NET API: HTTPS/JSON.
* .NET API -> Identity provider: validates sign-in results only.

## Boundaries
Everything under `web-react/` is this system. Other stacks in the monorepo have their own folders and bundles.

## Unverified
* The REST surface shared with Flutter is not yet written down as an OpenAPI file (planned, step 4).
* The identity provider, sign-in flow and session cookie behaviour are not chosen or implemented.
```

(Removed: "TanStack Query for server state, and structural rules enforced by lint and tests" - in-SPA tech belongs to L2/L3, not L1.)

## 3. `architecture/containers.md` (L2)

Full new contents:

```markdown
---
type: Container
title: "Containers"
description: "C4 level 2 - the web SPA and the .NET API; test doubles are listed separately."
resource: package.json
tags: [c4, container, react]
status: draft
---
# Containers

| Container | Technology | Role | In this repo |
|---|---|---|---|
| **Web SPA** | Vite build, React 19, TypeScript; static files on hosting or a CDN | Runs in the browser; talks HTTPS/JSON to the API. Sends `credentials: 'include'` (planned, step 10) | Yes, `web-react/` |
| **.NET API** | ASP.NET | Business data, sessions and CSRF validation ([ADR 0009](../adr/0009-cookie-session-and-csrf-owned-by-the-api.md)); validates sign-in results from the identity provider | No |
| **Identity provider** | Chosen per project | Authenticates the end user in the browser | No |

```
Browser (Web SPA) ──sign-in──> Identity provider
   │
   └──HTTPS/JSON──> .NET API ──validation only──> Identity provider
Hosting / CDN ──(static files)──> Browser
```

## Test doubles (not deployed)
| Double | Technology | Used by |
|---|---|---|
| **Mock API** | MSW | Integration tests and the e2e smoke run. Planned, see [plan](../backlog/bootstrap-plan.md) |

The SPA has no server of its own: there is no SSR and no backend-for-frontend inside this stack.
Layers inside the SPA (C4 level 3) are documented when they are built.

## Unverified
* `credentials: 'include'` and the sign-in redirect are planned, not implemented.
```

## 4. ADR edits

**ADR 0001** - `Decision` last paragraph / add a sentence at the end of `## Decision`:
```diff
+Enforcement is not in place yet: the `src/` layers and the boundaries lint land in step 3 of the
+[bootstrap plan](../backlog/bootstrap-plan.md); until then this ADR describes the target.
```

**ADR 0006** - `## Decision`:
```diff
-Lint, typecheck, tests and build must pass before a change is complete. TypeScript is pinned to 6.0.3.
+Format check (`prettier --check`), lint, typecheck, tests and build must pass before a change is complete
+(`pnpm check` runs all of them plus `okf.py --check`). TypeScript is pinned to 6.0.3.
```

**ADR 0007** - `## Decision`, replace the last sentence of the paragraph:
```diff
-Line coverage of non-generated code must be at least
-80% in CI. The e2e job runs after the build and is required on pull requests to `main`.
+Line coverage of non-generated code must be at least 80%. Today the threshold is enforced locally by
+`vitest.config.ts` (`coverage.thresholds`, run with `pnpm test:coverage`); the minimal CI gate (lint, typecheck,
+test, build) arrives in step 2 and the coverage, `okf.py` and e2e jobs in step 12. The e2e job runs after the build
+and is required on pull requests to `main`.
```

**`adr/_template-adr.md`** - in the YAML example:
```diff
-title: "ADR 0009: Short imperative statement of the decision"
+title: "ADR NNNN: Short imperative statement of the decision"
```

## 5. `backlog/bootstrap-plan.md`

```diff
-**Status.** Decisions recorded; step 1 in review. Nothing below is built. Delete this file when the last step is done and log it.
+**Status.** Step 1 done (scaffold, review fixes, ADRs 0001-0009). Steps 2-13 are not built. Delete this file when the last step is done and log it.
```
Step-12 row:
```diff
-| 12 | CI | ... | `ci: add web-react workflow` |
+| 12 | CI | ... | `ci: extend web-react workflow` |
```
Enforcement wording (so ADRs do not claim more than exists):
* Step 3 row: add "ADR 0001 enforcement starts here."
* Step 9 row: add "Coverage threshold (ADR 0007) is checked by `pnpm test:coverage`."
* Step 12 row: add "CI enforces `okf.py --check` and the coverage threshold."
* In "C4 mapping": `` `system-context.md` `` -> `` `context.md` ``; L1/L2 "(done in step 1)" -> "(draft from step 1)"; L2 "Mock API (MSW, test only)" -> "Test doubles (MSW, not deployed)".
* Decision 9 mentions "No co-author trailers or generated markers" - unchanged.

## 6. `backlog/typescript-7-upgrade.md` - peer range wording

```diff
-**Problem.** `typescript-eslint` 8.71.2 accepts TypeScript `>=4.8.4 <6.1.0` and throws on 7.0 ([ADR 0006](...)).
+**Problem.** The installed `typescript-eslint` 8.71.2 declares a TypeScript peer range of `>=4.8.4 <6.1.0`, which excludes 7.0
+([ADR 0006](../adr/0006-strict-typescript-and-lint.md)). Re-check the range when bumping; do not rely on this number.
```
Same softening in ADR 0006 `Consequences`: "`typescript-eslint` 8.71.2 rejects TypeScript 7" -> "`typescript-eslint` 8.71.2 declares a peer range that excludes TypeScript 7".

## 7. `log.md` - new line under `## 2026-10-19`

```markdown
* **Update**: Step 1 review fixes: renamed `system-context.md` to [context.md](architecture/context.md); L1 and L2 pages set to draft with Unverified notes and the identity-provider flow; MSW listed as a test double; ADRs [0001](adr/0001-layers-and-boundaries.md), [0006](adr/0006-strict-typescript-and-lint.md), [0007](adr/0007-test-tiers-and-coverage.md) and the ADR template aligned with what is enforced today; [bootstrap plan](backlog/bootstrap-plan.md) status and step 12 commit message corrected.
```

## Notes
* `status: draft` pages on L1/L2 must still pass `okf.py --check`; verify after applying.
* `map.md` descriptions for `containers.md` should match its new `description`.
