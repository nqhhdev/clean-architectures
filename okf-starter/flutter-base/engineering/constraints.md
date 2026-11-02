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
| Layers import only in the allowed direction | **choose**: an architecture test, an import lint, or review | [Components](../architecture/components/index.md) |
| Analyzer is clean | `flutter analyze` with **choose**: a lint package (`flutter_lints`, `very_good_analysis`, ...) | [Naming and Placement](conventions/naming.md) |
| Code is formatted | `dart format --set-exit-if-changed .` in CI | [Build](../workflows/build.md) |
| Generated code is **choose**: committed or git-ignored and rebuilt | `.gitignore` and CI step | [Build](../workflows/build.md) |
| Tests pass; goldens are judged on Linux/CI | CI `flutter test` | [Test](../workflows/test.md) |
| Coverage at least **choose**: `<N>%` | CI coverage check | [Test](../workflows/test.md) |
| No secrets in source or committed env files | **choose**: a secret scanner, or review | `<ADR to write>` |
