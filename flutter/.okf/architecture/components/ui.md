---
type: Component
title: "UI Layer"
description: "Feature Views and ViewModels plus ui/core (routing, theme, l10n, shared widgets) and the session screen."
resource: lib/ui
tags: [layer, ui, riverpod]
status: stable
---
# UI Layer

| Folder | Holds |
|---|---|
| `ui/emails/` | [`EmailsScreen`](../../../lib/ui/emails/emails_screen.dart) (View), [`EmailsViewModel`](../../../lib/ui/emails/emails_view_model.dart), [`EmailTile`](../../../lib/ui/emails/email_tile.dart) (row) |
| `ui/session/` | [`SignInScreen`](../../../lib/ui/session/sign_in_screen.dart), [`SignInViewModel`](../../../lib/ui/session/sign_in_view_model.dart) (placeholder, [ADR 0017](../../adr/0017-routing-go-router.md)) |
| `ui/core/routing/` | `routerProvider`, `AppRoutes` - [Navigation](../cross-cutting/navigation.md) |
| `ui/core/theme/` | `AppTheme`, `AppTextStyles`, `AppColors` - [Theming](../cross-cutting/theming.md) |
| `ui/core/l10n/` | ARB files, generated `AppLocalizations`, `errorMessage` - [Localization](../cross-cutting/localization.md) |
| `ui/core/` | [`AppStatusBanner`](../../../lib/ui/core/app_status_banner.dart), [`buildErrorWidget`](../../../lib/ui/core/error_widget.dart) |

Pattern: [View Model](../../engineering/patterns/view-model.md). Allowed imports: [Layered Architecture](../cross-cutting/layered-architecture.md).
