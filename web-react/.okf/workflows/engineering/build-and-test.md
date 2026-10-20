---
type: Workflow
title: "Build and test"
description: "Install, run the full pnpm check gate, run single tools, and what each script does."
tags: [workflow, build, test, check]
status: draft
---
# Build and test

Run from `web-react/`. Node 26 (`.nvmrc`); pnpm is the exact version in `packageManager` (Node 25+ has no corepack: `npm install -g pnpm@12.14.0`).

```sh
pnpm install --frozen-lockfile
pnpm check
```

`pnpm check` is the gate CI runs. In order: `generate` (orval client from `openapi/emails.yaml`), `format:check`,
`lint`, `typecheck`, `test:coverage` (80% lines), `build` (`tsc --noEmit` and Vite), `check:bundle` (no MSW, mock
entry or source maps in `dist/`), `scan:secrets`, `okf` (`python3 .okf/tools/okf.py --check`).

| Need | Command |
|---|---|
| Fix formatting | `pnpm format` |
| Lint only | `pnpm lint` |
| Types only | `pnpm typecheck` |
| Unit and component tests | `pnpm test` (`vitest run`; `pnpm exec vitest` to watch) |
| Coverage report | `pnpm test:coverage` (writes `coverage/`) |
| Regenerate the API client | `pnpm generate` (also runs before `test` and `build`) |
| Check the knowledge base | `pnpm okf`; `python3 .okf/tools/okf.py` also regenerates `map.md` |
| Browser smoke test | `pnpm e2e:install` once, then `pnpm e2e` ([Run e2e tests](run-e2e-tests.md)) |

CI also runs `pnpm audit --prod --audit-level=high` before `pnpm check` ([ADR 0018](../../adr/0018-ci-and-runtime-delivery.md)).
