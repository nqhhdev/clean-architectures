---
type: Task
title: "Restore jsx-a11y lint when it supports ESLint 10"
description: "eslint-plugin-jsx-a11y is dropped because its peer range stops at ESLint 9; add it back (strict) when a release supports ESLint 10."
tags: [backlog, lint, accessibility]
status: draft
---
# Restore jsx-a11y lint when it supports ESLint 10

[ADR 0016](../adr/0016-compiler-flags-alias-and-lint-rules.md) lists `jsx-a11y` strict among the lint rules.
`eslint-plugin-jsx-a11y` 6.10.2 declares peer `eslint ^3 || ... || ^9`, and plan decision 15 says ESLint is not pinned
back, so the plugin is not installed (2026-10-20, step 7).

**Do.** Re-check the peer range on each Dependabot cycle. When a release lists ESLint 10, add its `flatConfigs.strict` to
`eslint.config.js` and fix what it reports. Until then, accessibility is covered by Testing Library role queries in the
component tests.

**Alternative.** `@eslint-react/eslint-plugin` ships some accessibility rules; not chosen, to avoid a second React rule set.
