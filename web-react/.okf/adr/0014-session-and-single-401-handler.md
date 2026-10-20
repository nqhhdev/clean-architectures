---
type: ADR
title: "ADR 0014: SessionService is a port and the HTTP client is the single 401 handler"
description: "Session state sits behind a port, only the HTTP client reacts to 401, and start-up work is idempotent so React StrictMode double invocation is safe."
tags: [adr, session, auth, security]
status: stable
---
# ADR 0014: SessionService is a port and the HTTP client is the single 401 handler

**Status:** Accepted - 2026-10-19. Builds on [ADR 0009](0009-cookie-session-and-csrf-owned-by-the-api.md).

## Context
ADR 0009 keeps tokens out of JavaScript and leaves cookie issuing to the API. The client still needs one model of "who
is signed in" and one reaction to an expired session; the Flutter stack calls the latter its urgent failure handler.

## Decision
* `SessionService` is a port in `application/` (current snapshot, `bootstrap()`, `signOut()`, subscribe); the adapter is
  in `adapters/auth/`. The snapshot holds user information only, never a token.
* The HTTP client in `adapters/api/` is the single place that reacts to a 401: it maps it to `unauthorized`
  ([ADR 0012](0012-result-and-app-error.md)), calls `session.expire()` once, and the router guard
  ([ADR 0013](0013-data-loading-and-routing.md)) redirects. Screens never handle 401.
* Anything that starts work on mount (session bootstrap, a live connection) must be idempotent under double start.
  Session bootstrap is a memoised promise started from router `beforeLoad`, not from a bare `useEffect`.

## Consequences
**Good.** One 401 path to test; the same port serves the real adapter and a fake; no token reachable from script.
**Costly.** The 401 handler needs the real HTTP client, so it is tested in the security step, not earlier (done in step 10: see [ADR 0019](0019-client-side-security-baseline.md)).
**Alternatives rejected.** Each screen handling 401: duplicated and easy to miss. Session state in a client store: a
second owner of server data ([ADR 0003](0003-state-management.md)).

**Built in step 10** (decided by builder, awaiting owner review). `createHttpClient({ onUnauthorized })` is the only 401 check; `main.tsx` passes `() => session.expire()` and builds the cookie session after the client because each needs the other. `expire()` is on the port and idempotent. Details in [ADR 0019](0019-client-side-security-baseline.md).

## When to revisit
When the API or a backend-for-frontend defines refresh or silent re-authentication, or sessions span more than one site.
