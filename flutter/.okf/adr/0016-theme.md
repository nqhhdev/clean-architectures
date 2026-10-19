---
type: ADR
title: "ADR 0016: One app theme with ThemeExtensions; no inline styles"
description: "Styles and colors come from AppTheme and its ThemeExtensions; widgets never build a TextStyle or Color inline."
tags: [adr, theme, ui]
status: stable
---
# ADR 0016: One app theme with ThemeExtensions; no inline styles

**Status:** Accepted - 2026-10-19.

## Context
Inline `TextStyle` and colors in widgets ignore dark mode and make a restyle a search-and-replace.

## Decision
* [`AppTheme.light()` / `dark()`](../../lib/ui/core/theme/app_theme.dart): Material 3, `ColorScheme.fromSeed` from one seed color.
* Slots Material lacks are `ThemeExtension`s: [`AppTextStyles`](../../lib/ui/core/theme/app_text_styles.dart),
  [`AppColors`](../../lib/ui/core/theme/app_colors.dart); widgets read them with `context.appText` / `context.appColors`.
* No `TextStyle(` under `lib/ui/` outside `ui/core/theme/`: `findInlineTextStyles` in
  [`layer_rules.dart`](../../test/architecture/layer_rules.dart). No inline `Color(`: review only.

## Consequences
**Good.** Light and dark stay consistent; tested by [`app_theme_test.dart`](../../test/ui/core/app_theme_test.dart) and the
[`EmailTile` golden](../../test/ui/emails/email_tile_golden_test.dart).
**Costly.** Each new style needs an extension field plus `copyWith` and `lerp`.
**Alternatives rejected.** Constants files of styles (no dark mode, no lerp); a design-token package (overkill for a starter).

## When to revisit
When a design system supplies its own tokens.
