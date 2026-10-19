---
type: Convention
title: "Dart Style"
description: "Formatting, lints and language idioms used in the starter."
resource: analysis_options.yaml
tags: [convention, dart, style]
status: stable
---
# Dart Style

* `dart format` is the formatter; CI fails on unformatted code. `flutter analyze` is clean under [very_good_analysis](../technologies/very-good-analysis.md)
  with strict casts, inference and raw types ([ADR 0014](../../adr/0014-strict-lints-and-architecture-stand-ins.md)).
* Imports are always `package:clean_architecture/...` in `lib/` (`always_use_package_imports`); tests import `lib/` the same way and `test/support/` by relative path.
* Models and state are `@freezed abstract class` or `@immutable` with `const` constructors and `final` fields.
* `Result` is a `sealed class`; handle it with `switch` or `when`.
* An `// ignore:` needs a comment saying why (e.g. `one_member_abstracts` in [`logger.dart`](../../../lib/utils/logger.dart)).
* Document why, not what; a comment that restates the code is a defect.
