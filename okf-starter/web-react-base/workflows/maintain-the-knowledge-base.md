---
type: Workflow
title: "Maintain the Knowledge Base"
description: "How to add to, change and verify the .okf/ bundle so it stays true to the code and conformant to OKF v0.2."
tags: [workflow, okf, documentation]
status: draft
---
# Maintain the Knowledge Base

`.okf/` is an [Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format) v0.2 bundle. A page that disagrees with the code is a defect, so update
`.okf/` in the same change as the code.

## Steps
1. Find the directory whose question your fact answers (the root [index](../index.md) lists them).
2. Copy that directory's `_template-*.md` if it has one; write the one-sentence `description` first.
3. Link, do not copy: a fact lives in one file. Links are relative.
4. List the file in its directory's `index.md` as `* [Title](file.md) - description` (the description equals the frontmatter).
5. Add a line to the [Update Log](../log.md) under today's date.
6. Run `python3 .okf/tools/okf.py` (check, then regenerate `map.md`); `--fix` repairs index entries; `--check` only checks.

## Conventions
* `index.md` and `log.md` have no frontmatter (the root index carries only `okf_version`).
* `type` must be in the `# Concept types` list of the root index; add a value there first, never a near-synonym.
* `resource:` (optional) is the repo-relative path of the code a page maps to; the checker verifies it exists.
* Deprecate rather than delete (`status: deprecated`, say what replaced it). Never edit `map.md` by hand.

## Which directory
| You learned | Put it in |
|---|---|
| Why a choice was made | [adr/](../adr/index.md) |
| A naming or style rule | [conventions/](../engineering/conventions/index.md) |
| A rule a tool enforces | a row in [Constraints](../engineering/constraints.md) |
| How to write one more of something | [patterns/](../engineering/patterns/index.md) |
| A business slice or entity | [domains/](../domains/index.md) |
| A term a newcomer would pause on | [glossary/](../glossary/index.md) |
| A repeatable procedure | [workflows/](index.md) |
| A known gap | [backlog/](../backlog/index.md) |

**Verify:** `python3 .okf/tools/okf.py --check` exits 0.
