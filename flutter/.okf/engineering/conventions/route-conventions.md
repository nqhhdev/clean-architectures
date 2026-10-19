---
type: Convention
title: "Route Conventions"
description: "Paths are constants on AppRoutes, kebab-case; screens navigate with context.go, never a string literal."
resource: lib/ui/core/routing/app_router.dart
tags: [convention, navigation]
status: stable
---
# Route Conventions

* Every path is a `static const` on `AppRoutes` in [`app_router.dart`](../../../lib/ui/core/routing/app_router.dart): `inbox = '/'`, `signIn = '/sign-in'`.
* Paths are lower-case kebab-case.
* Navigate with `context.go(AppRoutes.x)` (as in [`AppStatusBanner`](../../../lib/ui/core/app_status_banner.dart)), not with a literal path.
* Redirect logic is a pure function (`sessionRedirect`) so it is unit-tested.

Unverified: deep-link handling and typed route parameters are not defined yet. Enforced by review. Mechanism: [Navigation](../../architecture/cross-cutting/navigation.md).
