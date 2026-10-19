---
type: ADR
title: "ADR 0004: Urgent failures go through one handler"
description: "Failures that need app-wide handling (expired session, no network) are routed to one UrgentFailureHandler before any screen shows its own error."
tags: [adr, errors, session, network]
status: stable
---
# ADR 0004: Urgent failures go through one handler

**Status:** Accepted - 2026-10-19. Idea from tmail-flutter `docs/adr/0103` ([Reference](../references/tmail-flutter.md)). Clearing amended by [ADR 0019](0019-urgent-failure-clearing-and-async-rules.md).

## Context
In a real app, expired-session and no-network failures were routed by one base controller. Code written later in a
different state-management style called the data layer directly, skipped that routing, and users saw a generic
toast instead of being sent to re-login.

## Decision
`ErrorType.unauthorized` and `ErrorType.network` mark urgent failures. Every ViewModel that receives a `Failure`
asks the [`UrgentFailureHandler`](../../lib/utils/urgent_failure_handler.dart) first and skips its own error UI
when it returns true; after a success it calls `clear()`. The default implementation,
[`AppStatusFailureHandler`](../../lib/config/app_status.dart), records the problem in `appStatusProvider`, which
[`AppStatusBanner`](../../lib/ui/core/app_status_banner.dart) shows. Replace `sessionExpired` handling with a real
re-login flow in your app.

## Consequences
**Good.** One place decides what "session expired" does; tested in
[`emails_view_model_test.dart`](../../test/ui/emails/emails_view_model_test.dart) and the integration/e2e tests.
**Costly.** Calling the handler is a convention each new ViewModel must follow; no type enforces it.
**Alternatives rejected.** Each screen handling 401 itself (the bug this prevents); a global Dio-style interceptor
(this starter uses `package:http`, and interceptors hide the flow from the ViewModel).

## When to revisit
When there is a real auth flow, or an HTTP stack with a native interceptor.
