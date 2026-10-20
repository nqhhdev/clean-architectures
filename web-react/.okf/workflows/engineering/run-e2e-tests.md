---
type: Workflow
title: "Run e2e tests"
description: "Install chromium, run the Playwright smoke test against the mock build, and how CI caches the browser."
tags: [workflow, e2e, playwright]
status: draft
---
# Run e2e tests

From `web-react/`:

```sh
pnpm e2e:install   # once: playwright install chromium
pnpm e2e
```

`pnpm e2e` runs `pnpm generate`, `vite build --mode mock`, `scripts/check-bundle.mjs --expect-mock dist-mock` (fails if
the mock build lacks the MSW worker) and `playwright test`. Playwright starts `vite preview --mode mock` on port 4173
itself (`playwright.config.ts`); an already running server is reused outside CI.

* Specs are in `e2e/`. The smoke test opens `/`, follows the Emails link and expects the two seeded emails.
* Traces are kept on failure in `test-results/` (git-ignored); `playwright show-trace <file>` opens one.
* In CI the `e2e` job runs after install, caches `~/.cache/ms-playwright` keyed by the resolved `@playwright/test`
  version, and installs system dependencies on a cache miss ([ADR 0018](../../adr/0018-ci-and-runtime-delivery.md)).
* e2e is not part of `pnpm check`.
