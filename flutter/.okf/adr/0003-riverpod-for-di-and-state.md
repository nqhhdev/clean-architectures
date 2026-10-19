---
type: ADR
title: "ADR 0003: Riverpod for dependency injection and ViewModel state"
description: "Use flutter_riverpod for both DI and state: ViewModels are AsyncNotifiers, providers in config/ pick implementations."
tags: [adr, riverpod, state-management, di]
status: stable
---
# ADR 0003: Riverpod for dependency injection and ViewModel state

**Status:** Accepted - 2026-10-19 (owner's choice).

## Context
The official guide recommends dependency injection and leaves state management to preference; its own examples use
`provider` with `ChangeNotifier`.

## Decision
`flutter_riverpod` (3.x). A ViewModel is an `AsyncNotifier<State>` with an immutable state class; Views are
`ConsumerWidget`s. Providers that choose concrete implementations live in
[`config/providers/`](../../lib/config/providers/core_providers.dart); tests replace them with `ProviderScope` /
`ProviderContainer` overrides. `utils`, `domain` and `data` import neither Flutter nor Riverpod.

## Consequences
**Good.** DI and state in one tool; overriding a provider is the whole test seam.
**Costly.** Team must learn provider/notifier concepts. Pitfalls seen in a real app (tmail-flutter ADR 0092):
`StateNotifier` moved to `legacy.dart`; use `ref.watch`, not `ref.read`, to depend on providers inside `build`;
providers auto-dispose unless `keepAlive`; `riverpod_generator`/`riverpod_lint` can conflict with a pinned analyzer.
**Alternatives rejected.** Provider + ChangeNotifier (the guide's example, fewer features); Bloc (more boilerplate).

## When to revisit
If code generation (`riverpod_generator`) becomes worth its analyzer constraints.
