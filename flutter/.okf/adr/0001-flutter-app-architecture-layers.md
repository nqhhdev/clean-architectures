---
type: ADR
title: "ADR 0001: Follow the Flutter app-architecture guide - UI, Data and optional Domain layers"
description: "Organise lib/ by architectural role as the official Flutter guide describes, and enforce the dependency directions with a test."
tags: [adr, architecture, layers]
status: stable
---
# ADR 0001: Follow the Flutter app-architecture guide - UI, Data and optional Domain layers

**Status:** Accepted - 2026-10-19. Source: docs.flutter.dev/app-architecture (guide and recommendations), read 2026-10-19.
The idea of enforcing layering by test is adapted from `clean-architecture-template` (.NET). Use cases added by [ADR 0010](0010-use-cases-layer.md).

## Context
The .NET template this starter descends from uses SharedKernel / Domain / Application / Infrastructure / Web.Api.
Flutter has its own published structure: a UI layer (Views and ViewModels), a Data layer (Repositories and
Services) and an optional Domain layer (use cases). Following it keeps the code recognisable to Flutter developers.

## Decision
`lib/` has the layers in [Layered Architecture](../architecture/cross-cutting/layered-architecture.md) and
[Components](../architecture/components/index.md): `ui`, `domain`, `data/repositories`, `data/services`, `config`, `utils`.
Repositories do not depend on each other, services hold no state, and only `config/` and `main.dart` see concrete
implementations. The direction rules are enforced by
[`layers_test.dart`](../../test/architecture/layers_test.dart).

## Consequences
**Good.** Standard Flutter shape; swapping a data source touches `data/` and `config/` only; the rules fail a
test, not a review.
**Costly.** The enforcement is an import scan, not a compiler boundary: it ignores `part` files and conditional
imports. Use cases are not shipped (see below), so a team that needs them adds `domain/use_cases/`.
**Alternatives rejected.** Feature-first folders with a full data/domain/presentation triple per feature (what
tmail-flutter does, see [Reference](../references/tmail-flutter.md)): fine at scale, but makes the layer rule a
per-feature rule and departs from the official guide's vocabulary. A .NET-style Application layer of handlers:
the guide treats use cases as conditional, and the ViewModel already is the application logic for one screen.

## When to revisit
When ViewModels start to share logic or span several repositories (add use cases), or when `flutter/` outgrows one
package (split with Dart pub workspaces).
