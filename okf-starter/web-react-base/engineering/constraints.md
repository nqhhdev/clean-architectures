---
type: Constraint
title: "Constraints"
description: "Every rule the code must keep, what enforces it, and the page that owns the reasoning - re-check before you finish."
tags: [rules, review]
status: draft
---
# Constraints

A rule nobody enforces is a wish: name the tool, or write "review" honestly. To change a rule, write or supersede an
[ADR](../adr/index.md) first. Rows marked **choose** are common starting points; keep, change or delete them.

| Rule | Enforced by | Owner |
|---|---|---|
| Layers import only in the allowed direction | **choose**: a boundaries / import lint rule, dependency-cruiser, or review | [Components](../architecture/components/index.md) |
| Type-checks in strict mode | `tsc --noEmit` with `strict: true` | [Build](../workflows/build.md) |
| Lint is clean | **choose**: ESLint config, Biome, or another linter | [Naming and Placement](conventions/naming.md) |
| Code is formatted | **choose**: Prettier / Biome check in CI | [Build](../workflows/build.md) |
| Data from the network is validated at the boundary | **choose**: a schema library, generated types, or review | [Adapters Layer](../architecture/components/adapters.md) |
| Tests pass; visual snapshots are judged on Linux/CI | CI test job | [Test](../workflows/test.md) |
| Coverage at least **choose**: `<N>%` | test runner coverage threshold | [Test](../workflows/test.md) |
| No secrets in client code or committed env files | **choose**: a secret scanner, or review | `<ADR to write>` |
