---
type: ADR
title: "ADR 0009: Cookie session and CSRF validation are owned by the API"
description: "The SPA sends credentials and a CSRF header and never stores tokens; issuing cookies and validating CSRF belong to the API or a BFF."
tags: [adr, security, auth, csrf]
status: stable
---
# ADR 0009: Cookie session and CSRF validation are owned by the API

**Status:** Accepted - 2026-10-19. See also [ADR 0014](0014-session-and-single-401-handler.md) for the client-side session model.

## Context
A browser SPA cannot set httpOnly cookies and cannot validate CSRF. Tokens kept in JavaScript-reachable storage are exposed to XSS.

## Decision
The session is an httpOnly, Secure, SameSite cookie issued by the API or a backend-for-frontend. The SPA sends requests with
`credentials: 'include'`, adds a CSRF header through one hook in the API client, and never stores a token in `localStorage`
or `sessionStorage`. Issuing cookies and validating CSRF are the API's job; this stack implements and tests only the client
side. The identity provider stays a per-project choice. Server-side enforcement is tracked in the
[backlog](../backlog/server-side-session-enforcement.md).

## Consequences
**Good.** No token reachable from script; the client side is small and testable.
**Costly.** Sign-in is a placeholder until the API issues cookies; the CSRF header name and cookie settings must be agreed with the API.
**Alternatives rejected.** Bearer tokens in memory with a refresh cookie: still exposes an access token to XSS. Tokens in `localStorage`: exposed.

## When to revisit
When the API or BFF issues sessions, or if the deployment puts the SPA and API on different sites.
