---
type: ADR
title: "ADR 0008: Each stack keeps its own OKF knowledge bundle in .okf/"
description: "Project knowledge lives in a per-stack Open Knowledge Format v0.2 bundle with the template layout, checked by tools/okf.py."
tags: [adr, documentation, okf]
status: stable
---
# ADR 0008: Each stack keeps its own OKF knowledge bundle in .okf/

**Status:** Accepted - 2026-10-19. Mirrors `clean-architecture-template` ADR 0015.

## Context
The knowledge for a stack cannot be shared with another stack (different layers, tools, patterns), and small linked files
are easier to read than long documents.

## Decision
`flutter/.okf/` is an [Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format) v0.2
bundle using the same directory layout as the template (`architecture/`, `engineering/`, `domains/`, `adr/`,
`workflows/`, `glossary/`, `backlog/`), one concept per file, with `index.md`, `log.md` and a generated `map.md`.
[`tools/okf.py`](../tools/okf.py) checks it. Directories and standard pages stay even when unused; those are marked
`status: draft` until the real project fills them. See [Maintain the Knowledge Base](../workflows/process/maintain-the-knowledge-base.md).

## Consequences
**Good.** Stable addresses for every rule; readers load only what they need. **Costly.** Many files that can rot;
only works if updated in the same change as the code.
**Alternatives rejected.** One big README; a shared bundle at the monorepo root.

## When to revisit
When a second stack needs to reuse concepts: extract them rather than copying.
