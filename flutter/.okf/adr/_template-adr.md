---
type: Template
title: "ADR Template"
description: "Copy this when recording an architecture decision."
tags: [template, adr]
status: stable
---
# ADR Template

> Copy to `.okf/adr/NNNN-<slug>.md` using the next free number, replace everything, add it to
> [Architecture Decision Records](index.md) and a line to [Knowledge Base Update Log](../log.md).
> Delete this quote block.

```yaml
---
type: ADR
title: "ADR 0009: Short imperative statement of the decision"
description: "One sentence: what was decided and the shape of the trade-off."
tags: [adr, topic]
status: stable        # draft while under discussion
---
```

**Status:** Proposed | Accepted | Superseded by ADR NNNN (`NNNN-slug.md`) - with the date.

## Context
The forces in play. Factual, no advocacy yet.

## Decision
What was decided, in the present tense. Specific enough that someone can tell whether code complies.

## Consequences
**Good.** What this buys. **Costly.** What it costs, honestly. **Alternatives rejected.** Each with the reason.

## When to revisit
The condition that would reopen this.

---
Write an ADR when the decision is expensive to reverse, when a reasonable engineer would choose otherwise, or
when you have explained the reasoning twice. A choice with no real alternative is a
[convention](../engineering/conventions/index.md). Supersede rather than edit an accepted ADR.
