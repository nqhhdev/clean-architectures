---
type: Reference
title: "Starter README"
description: "How to copy this starter into a repo as .okf/ and fill it in."
tags: [starter, okf]
status: draft
---
# Starter README

A generic React web knowledge base in [Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format) v0.2. Every page is `status: draft` and holds
placeholders in `<angle brackets>`.

## Use it
1. Copy this folder to `<your-repo>/.okf` (for example `cp -R okf-starter/web-react-base <your-repo>/.okf`).
2. Fill [System Context](architecture/context.md), the containers and the components from the real code, layer by layer.
3. Link or mirror the repo's own ADRs in [adr/](adr/index.md), keeping their original numbers.
4. Pick your patterns in [Patterns](engineering/patterns/index.md) and record each choice as an ADR; fill [Constraints](engineering/constraints.md).
5. Replace the commands in [workflows/](workflows/index.md) with the ones the repo really uses.
6. Turn a page to `status: stable` once it matches the code. Add a line to [log.md](log.md).
7. Run `python3 .okf/tools/okf.py` from the repo root (checks, then regenerates `map.md`); run it with `--check` in CI or a pre-commit hook.
8. Point each coding agent at `.okf/index.md`, see [Agent Adapters](workflows/adapters.md).

Delete this file once the bundle is filled, and remove its line from [index.md](index.md).
