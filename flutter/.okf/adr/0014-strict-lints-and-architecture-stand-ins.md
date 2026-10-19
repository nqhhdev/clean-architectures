---
type: ADR
title: "ADR 0014: Strict analysis with very_good_analysis, plus architecture-test stand-ins for missing lints"
description: "very_good_analysis and strict analyzer modes gate every change; rules no lint covers are checked in layer_rules.dart."
tags: [adr, lints, analysis, riverpod]
status: stable
---
# ADR 0014: Strict analysis with very_good_analysis, plus architecture-test stand-ins for missing lints

**Status:** Accepted - 2026-10-19.

## Context
`flutter_lints` let implicit `dynamic`, raw types and relative imports through. `riverpod_lint` cannot be installed on this SDK
(per [`layer_rules.dart`](../../test/architecture/layer_rules.dart)), so `ref.read` inside `build()` was review-only.

## Decision
* [`analysis_options.yaml`](../../analysis_options.yaml) includes `very_good_analysis` and sets `strict-casts`, `strict-inference`, `strict-raw-types`.
* `always_use_package_imports` on; `public_member_api_docs`, `cascade_invocations`, `prefer_relative_imports` off.
* Generated code (`*.g.dart`, `*.freezed.dart`, `lib/ui/core/l10n/generated/`) and `build/` are excluded.
* A missing lint becomes a pure checker in `layer_rules.dart`, run by [`layers_test.dart`](../../test/architecture/layers_test.dart):
  `findRefReadInNotifierBuild` (here) and `findInlineTextStyles` ([ADR 0016](0016-theme.md)).

## Consequences
**Good.** `flutter analyze` catches type holes; stand-in rules are themselves tested on bad sources.
**Costly.** More `// ignore:` lines with reasons (e.g. `one_member_abstracts` in `utils/logger.dart`); stand-ins are regex scans, not type-aware.
**Alternatives rejected.** Staying on `flutter_lints` (too lax); leaving `ref.read` in `build()` to review (missed easily).

## When to revisit
When `riverpod_lint` installs on the pinned SDK: enable it and delete `findRefReadInNotifierBuild`.
