---
type: ADR
title: "ADR 0017: go_router with a session redirect and a placeholder sign-in"
description: "go_router owns navigation; an expired session redirects to a placeholder sign-in screen until real auth exists."
tags: [adr, navigation, routing, session]
status: stable
---
# ADR 0017: go_router with a session redirect and a placeholder sign-in

**Status:** Accepted - 2026-10-19. The official guide recommends go_router.

## Context
With one screen and no router, a 401 could only show a banner; there was nowhere to send the user.

## Decision
* Routes live in [`app_router.dart`](../../lib/ui/core/routing/app_router.dart): `AppRoutes.inbox` (`/`), `AppRoutes.signIn` (`/sign-in`).
  `routerProvider` builds the `GoRouter`; [`App`](../../lib/app.dart) uses `MaterialApp.router`.
* The router refreshes when `appStatusProvider.sessionExpired` changes; the pure `sessionRedirect` sends an expired session to sign-in and back.
* [`SignInScreen`](../../lib/ui/session/sign_in_screen.dart) / [`SignInViewModel`](../../lib/ui/session/sign_in_view_model.dart) are a
  placeholder: `signIn` only clears `ErrorType.unauthorized`. `authTokenSourceProvider` returns null.
* Real authentication and token storage replace `signIn` and `authTokenSourceProvider` ([backlog](../backlog/real-auth-flow.md)).

## Consequences
**Good.** A 401 anywhere lands on sign-in with no per-screen code; tested in [`app_router_test.dart`](../../test/ui/core/app_router_test.dart).
**Costly.** The placeholder sign-in authenticates nothing. go_router is not allowed outside `ui`/`config`.
**Alternatives rejected.** Imperative `Navigator` (no declarative redirect); generated routers (more codegen).

## When to revisit
When the real auth flow lands, or deep links need typed routes.
