---
type: ADR
title: "ADR 0011: ds/ owns tokens and components; features may add layout-only CSS Modules"
description: "Design tokens are CSS variables declared in ds/ with light and dark via [data-theme]; features compose ds components and may own CSS Modules for layout only."
tags: [adr, styling, design-system, css]
status: stable
---
# ADR 0011: ds/ owns tokens and components; features may add layout-only CSS Modules

**Status:** Accepted - 2026-10-19.

## Context
The plan already rules out Tailwind (decision 5): styling is CSS variables plus CSS Modules. Without a rule on who may
write CSS, features grow their own colours, fonts and spacing and the theme stops being a single source.

## Decision
* `ds/` holds the design system components, their CSS Modules and the design tokens (colour, typography, spacing) as
  CSS variables. Light and dark themes switch through the `[data-theme]` attribute.
* `ds/` imports React only. It takes already-translated props and has no i18n dependency and no domain knowledge.
* A feature composes `ds/` components. A feature may own `*.module.css` files **for layout only** (grid, flex,
  position, sizing). Every colour, typography and spacing value in them comes from a `ds/` CSS variable; a feature never
  declares a token or a literal colour, font or spacing value.
* No inline `style` prop ([ADR 0016](0016-compiler-flags-alias-and-lint-rules.md)).
* The first `ds/` primitives (for example page, stack, inline) land with the cross-cutting step of the
  bootstrap plan.

"Layout only" is a review rule today. No tool enforces it; a stylelint rule is possible but not chosen.

## Consequences
**Good.** One source for the look; dark mode needs no feature changes; layout one-offs do not wait for a new `ds/` component.
**Costly.** Reviewers must catch token bypasses in feature CSS; `ds/` needs a few layout primitives early.
**Alternatives rejected.** Tailwind: already declined (plan decision 5). CSS only in `ds/`, features with none: forces a
`ds/` primitive for every one-off layout. CSS-in-JS: runtime cost and a second styling system.

## When to revisit
When token bypasses reach review repeatedly (add a lint rule), or when a second app needs the design system (extract `ds/`).
