---
type: Workflow
title: "Build"
description: "Install dependencies, generate code, type-check, lint, format and build the production bundle."
tags: [workflow, build]
status: draft
---
# Build

Replace each command with the repo's script (`npm`, `pnpm`, `yarn` or `bun`; check `package.json`).

```sh
<pm> install
<pm> run generate      # only if the repo generates API clients or types
<pm> run typecheck     # tsc --noEmit
<pm> run lint
<pm> run format:check
<pm> run build
```

**Verify:** all commands exit 0. Deployment: `<link the delivery page or ADR>`.
