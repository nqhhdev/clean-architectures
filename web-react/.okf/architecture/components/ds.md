---
type: Component
title: "Design system layer"
description: "C4 level 3 - src/ds/: CSS-variable tokens with light and dark themes, Page, Stack, Inline and Heading."
resource: src/ds
tags: [c4, components, ds, css]
status: draft
---
# Design system layer

`src/ds/` holds presentational building blocks. It imports React only: no domain, no i18n, no TanStack (K1, K19). Text
arrives as already-translated props or children.

| File | Contents |
|---|---|
| `tokens.css` | Design tokens as CSS variables; light is the default, dark under `[data-theme='dark']` |
| `layout.tsx`, `layout.module.css` | `Page` (`main`), `Stack` (vertical), `Inline` (horizontal); `gap` is 1-4 and maps to `--space-<gap>`; `as` picks the element |
| `heading.tsx` | `Heading` |

* Tokens are declared only here (K4). A feature may own a `*.module.css` for layout but takes colour, type and spacing
  from these variables ([ADR 0011](../../adr/0011-design-system-and-styling.md)).
* The theme is switched by the `data-theme` attribute on `<html>`, set by `app/theme.ts` from the OS preference.
