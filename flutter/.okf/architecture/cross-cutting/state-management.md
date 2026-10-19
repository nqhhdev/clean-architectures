---
type: Mechanism
title: "State Management"
description: "Riverpod notifiers own state; providers in config/providers pick implementations; each shared state has one owner."
tags: [riverpod, state]
status: stable
---
# State Management

* ViewModel = `AsyncNotifierProvider<ViewModel, State>` (or `NotifierProvider`); State is immutable.
* Shared state has one owning notifier ([ADR 0005](../../adr/0005-single-source-of-truth-for-state.md)); the example is
  [`appStatusProvider`](../../../lib/config/app_status.dart).
* Providers that pick implementations live in [`config/providers/`](../../../lib/config/providers/core_providers.dart), one file per feature.
* In `build()`, depend on other providers with `ref.watch`; in methods and callbacks use `ref.read`; after `await` check `ref.mounted`.
* Tests override providers; see [Fake over Mock](../../engineering/patterns/fake-over-mock.md).

Rules and enforcement: [Constraints](../../engineering/constraints.md). Decision: [ADR 0003](../../adr/0003-riverpod-for-di-and-state.md).
