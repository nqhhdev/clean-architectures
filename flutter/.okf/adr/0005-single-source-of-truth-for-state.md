---
type: ADR
title: "ADR 0005: One owner per piece of shared state"
description: "Each piece of state used by several screens has exactly one Riverpod notifier that owns it; screens read and write through it."
tags: [adr, state-management]
status: stable
---
# ADR 0005: One owner per piece of shared state

**Status:** Accepted - 2026-10-19. Idea from tmail-flutter `docs/adr/0093` ([Reference](../references/tmail-flutter.md)).

## Context
A search filter lived in two independent objects: chips wrote one, an advanced form edited another, and paging cursors
were mixed with user intent. Chips and results disagreed (three bug reports).

## Decision
Shared state has one owning notifier. Screens read it there and write through its methods; none keeps its own copy.
Keep paging cursors apart from user intent. Add a draft/staging copy only if the product needs cancel-revert. A
notifier that must survive navigation uses `keepAlive`. Example in the starter:
[`appStatusProvider`](../../lib/config/app_status.dart).

## Consequences
**Good.** Surfaces cannot disagree. **Costly.** A discipline, not a mechanism: nothing stops a second copy appearing.
**Alternatives rejected.** Local widget state mirrored to a controller.

## When to revisit
When the first genuinely shared state beyond app status appears: write its owner and link it here.
