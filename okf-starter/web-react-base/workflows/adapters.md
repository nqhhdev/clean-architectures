---
type: Reference
title: "Agent Adapters"
description: "Every coding agent is pointed at .okf/index.md; no agent gets its own copy of the knowledge."
tags: [agents, okf]
status: draft
---
# Agent Adapters

The knowledge lives only in `.okf/`. Each coding agent or IDE assistant the team uses gets one short instruction file in
the format that tool expects, and that file says little more than: read `.okf/index.md` first, keep the rules in
[Constraints](../engineering/constraints.md), and run the checks in [Build](build.md) and [Test](test.md) before finishing.

Keep those files short and free of facts, so there is one place to update. Whether they are committed or kept local is a
team decision; record it in the [Update Log](../log.md).
