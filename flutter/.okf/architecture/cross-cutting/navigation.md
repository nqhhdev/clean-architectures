---
type: Mechanism
title: "Navigation"
description: "go_router routes in ui/core/routing; an expired session redirects to sign-in and back."
resource: lib/ui/core/routing/app_router.dart
tags: [routing, navigation, session]
status: stable
---
# Navigation

| Route | Path | Screen |
|---|---|---|
| `AppRoutes.inbox` | `/` | [`EmailsScreen`](../../../lib/ui/emails/emails_screen.dart) |
| `AppRoutes.signIn` | `/sign-in` | [`SignInScreen`](../../../lib/ui/session/sign_in_screen.dart) |

* [`routerProvider`](../../../lib/ui/core/routing/app_router.dart) builds the `GoRouter`; [`App`](../../../lib/app.dart) passes it to `MaterialApp.router`.
* A 401 sets `AppStatus.sessionExpired` ([Error Handling](error-handling.md)); the router listens to that flag and
  `sessionRedirect` moves the user to `/sign-in`, and back to `/` once it is cleared.
* `AppStatusBanner`'s Sign in action calls `context.go(AppRoutes.signIn)`.

Naming: [Route Conventions](../../engineering/conventions/route-conventions.md). Decision: [ADR 0017](../../adr/0017-routing-go-router.md).
Tests: [`app_router_test.dart`](../../../test/ui/core/app_router_test.dart).
