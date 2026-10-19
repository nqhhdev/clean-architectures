---
type: Workflow
title: "Branching and Pull Requests"
description: "Commit rules (decided) and the branching and review model (still for the owning team to set)."
tags: [workflow, git, commits]
status: draft
---

# Branching and Pull Requests

## Commit rules (decided)
* **One logical part per commit** so each commit is easy to review. Example split: repo scaffolding, the app code, docs, CI.
* **Short, clear message** in Conventional Commits form (`feat(flutter): ...`, `docs(flutter): ...`, `ci: ...`). One line; do not describe the code.
* **No extra author or trailer**: no `Co-Authored-By`, no tool attribution. The author is the owner.

## Branching and review (to decide)
> **Draft.** Record the team branching model, review rules and merge policy here. Dependabot and CI are described in
> [CI Pipeline](../../architecture/delivery/ci-pipeline.md).
