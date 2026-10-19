---
type: Workflow
title: "Maintain the Knowledge Base"
description: "How to add to, change and verify the .okf/ bundle so it stays true to the code and conformant to OKF v0.2."
resource: .okf/tools/okf.py
tags: [workflow, okf, documentation]
status: stable
---
# Maintain the Knowledge Base

`.okf/` is an [Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format) v0.2 bundle
([ADR 0008](../../adr/0008-okf-knowledge-base-per-stack.md)). A concept that disagrees with the code is a defect, so update
`.okf/` in the same change as the code.

## Steps
1. Find the directory whose question your fact answers (the root [index](../../index.md) lists them). Do not put knowledge in a README or a code comment.
2. Copy that directory's `_template-*.md`, replace everything, write the one-sentence `description` first.
3. Link, do not copy: a fact lives in one file; others link with the target's `title`. Links are relative.
4. Add the file to its directory's `index.md` as `* [Title](file.md) - description` (the description equals the frontmatter).
5. Add a line to the [Update Log](../../log.md) under today's date.
6. Run `python3 .okf/tools/okf.py` (check, then regenerate `map.md`); `--fix` repairs index entries; `--check` only checks.

## Conventions
* `index.md` and `log.md` are reserved and have no frontmatter (the root index carries only `okf_version`).
* `type` must be in the `# Concept types` list of the root index; add a value there first, never a near-synonym.
* `resource:` is the stack-relative path of the code a concept maps to; the checker verifies it exists.
* Do not add `generated:` or any provenance marker. Write pages the way a teammate would.
* Deprecate rather than delete (`status: deprecated`, say what replaced it). `map.md` is generated.
* Draft pages keep a place in the layout until the real project fills them.

## Which directory
| You learned | Put it in |
|---|---|
| Why a choice was made | [adr/](../../adr/index.md) (supersede, do not edit) |
| A naming or style rule | [conventions/](../../engineering/conventions/index.md) |
| A rule a test enforces | a row in [Constraints](../../engineering/constraints.md) |
| How a mechanism works end to end | [cross-cutting/](../../architecture/cross-cutting/index.md) |
| How to write one more of something | [patterns/](../../engineering/patterns/index.md) |
| A new dependency | [technologies/](../../engineering/technologies/index.md) |
| A business entity or slice | [domains/](../../domains/index.md) |
| A term a newcomer would pause on | [glossary/](../../glossary/index.md) |
| A repeatable procedure | [workflows/](../../workflows/index.md) |
| A known gap | [backlog/](../../backlog/index.md) |

**Verify:** `python3 .okf/tools/okf.py --check` exits 0.
