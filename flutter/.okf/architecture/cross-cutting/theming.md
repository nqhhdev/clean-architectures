---
type: Mechanism
title: "Theming"
description: "AppTheme builds light and dark Material 3 themes from one seed, with ThemeExtensions for app-specific styles."
resource: lib/ui/core/theme/app_theme.dart
tags: [theme, ui, styles]
status: stable
---
# Theming

| Piece | Where | Read with |
|---|---|---|
| `AppTheme.light()` / `dark()` | [`app_theme.dart`](../../../lib/ui/core/theme/app_theme.dart) | `Theme.of(context)` |
| `AppTextStyles` (`unreadTitle`, `readTitle`) | [`app_text_styles.dart`](../../../lib/ui/core/theme/app_text_styles.dart) | `context.appText` |
| `AppColors` (`unreadAccent`, `statusBanner`) | [`app_colors.dart`](../../../lib/ui/core/theme/app_colors.dart) | `context.appColors` |

* [`App`](../../../lib/app.dart) sets `theme` and `darkTheme`; the platform picks.
* A new style or color is a field on an extension, filled in `AppTheme._build`.
* Tests: [`app_theme_test.dart`](../../../test/ui/core/app_theme_test.dart); golden [`email_tile_golden_test.dart`](../../../test/ui/emails/email_tile_golden_test.dart).

Rules: [Constraints](../../engineering/constraints.md). Decision: [ADR 0016](../../adr/0016-theme.md).
