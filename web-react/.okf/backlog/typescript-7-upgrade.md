---
type: Task
title: "TypeScript 7 upgrade"
description: "TypeScript is pinned to 6.0.3 because typescript-eslint does not support 7 yet."
tags: [backlog, tooling]
status: draft
---
# TypeScript 7 upgrade

**Problem.** The installed `typescript-eslint` 8.71.2 declares a TypeScript peer range of `>=4.8.4 <6.1.0`, which excludes 7.0
([ADR 0006](../adr/0006-strict-typescript-and-lint.md)). Re-check the range when bumping; do not rely on this number.

**Done when** a `typescript-eslint` release supports TypeScript 7, the pin is bumped with lint, typecheck, tests and build green, ADR 0006 is updated or superseded, and this file is deleted and logged.
