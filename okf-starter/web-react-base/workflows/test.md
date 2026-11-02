---
type: Workflow
title: "Test"
description: "Run unit, component and end-to-end tests, and where visual snapshots are canonical."
tags: [workflow, test]
status: draft
---
# Test

```sh
<pm> run test             # unit + component (Vitest, Jest, ...)
<pm> run test:coverage
<pm> run e2e              # browser tests (Playwright, Cypress, ...)
```

## Visual snapshots
Screenshot comparisons differ between operating systems (fonts, anti-aliasing), so **Linux / CI is canonical**.
Tag or separate them, skip them locally on macOS or Windows, and run or update them only on Linux, in CI or in a Linux container.

**Verify:** the test job exits 0 on CI.
