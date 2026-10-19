---
type: Mechanism
title: "Layered Architecture"
description: "The layers of lib/ and the single direction in which imports may point."
resource: test/architecture/layer_rules.dart
tags: [architecture, layers, dependencies]
status: stable
---
# Layered Architecture

| Layer | May import (besides itself) | Flutter allowed |
|---|---|---|
| `utils` | - | none |
| `domain` (models, errors) | utils | none |
| `data/services` | domain, utils | `flutter/services.dart`, `flutter/foundation.dart` |
| `data/repositories` | domain, utils, data/services | `flutter/foundation.dart` |
| `domain/use_cases` | domain, utils, data/repositories | none |
| `config` | domain, domain/use_cases, utils, data/services, data/repositories | all |
| `ui` | domain, domain/use_cases, utils, data/repositories, config | all |

`lib/main.dart` and `lib/app.dart` (the composition root) may import anything. The restricted layers (first five rows) also never
import `package:riverpod`, `package:go_router` or `dart:ui`. Generated files are exempt.

## Enforcement
[`layer_rules.dart`](../../../test/architecture/layer_rules.dart) is the source of truth: pure checkers over file contents, run by
[`layers_test.dart`](../../../test/architecture/layers_test.dart) on `lib/` and on deliberately bad sources, so a green run means the
rules work. It scans imports only: no `part` or conditional-import tracking.
Why: [ADR 0001](../../adr/0001-flutter-app-architecture-layers.md), [ADR 0010](../../adr/0010-use-cases-layer.md). Every rule: [Constraints](../../engineering/constraints.md).
