---
type: ADR
title: "ADR 0019: Urgent failures clear per type on real responses; ViewModel actions are guarded"
description: "Only a real HTTP response clears offline or session-expired, one type at a time; ViewModel actions never interleave."
tags: [adr, errors, session, network, view-model]
status: stable
---
# ADR 0019: Urgent failures clear per type on real responses; ViewModel actions are guarded

**Status:** Accepted - 2026-10-19. Amends [ADR 0004](0004-urgent-failures-single-handler.md): ViewModels no longer call `clear()`.

## Context
Under ADR 0004 a ViewModel cleared the urgent state after any success, so a cache hit could hide "offline" and one clear hid
both problems. Two quick taps could also run two writes against the same cache.

## Decision
* [`AppStatus`](../../lib/config/app_status.dart) tracks `offline` and `sessionExpired` separately;
  [`UrgentFailureHandler.clear`](../../lib/utils/urgent_failure_handler.dart) takes one `ErrorType`.
* `ApiClient.onResponse`, wired in [`core_providers.dart`](../../lib/config/providers/core_providers.dart), clears `network` on any
  response and `unauthorized` on a 2xx. ViewModels only call `handle`; the placeholder sign-in clears `unauthorized` ([ADR 0017](0017-routing-go-router.md)).
* [`EmailsViewModel`](../../lib/ui/emails/emails_view_model.dart): an in-flight guard ignores actions while one runs; actions run in
  `AsyncValue.guard`; `ref.mounted` is checked after `await`; an unexpected exception goes to the `CrashReporter` and shows `Common.Unknown`, keeping the list.

## Consequences
**Good.** The banner reflects the network, not the cache. Tested in [`app_status_test.dart`](../../test/config/app_status_test.dart),
[`emails_view_model_test.dart`](../../test/ui/emails/emails_view_model_test.dart) and [`inbox_integration_test.dart`](../../test/integration/inbox_integration_test.dart).
**Costly.** A tap during an action is dropped silently. The guard is a convention each ViewModel copies.
**Alternatives rejected.** Queueing actions (stale intents run late); clearing in the ViewModel (the bug above).

## When to revisit
When a ViewModel needs parallel actions, or a connectivity package supplies network state.
