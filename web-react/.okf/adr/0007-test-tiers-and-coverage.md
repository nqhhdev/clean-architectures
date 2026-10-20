---
type: ADR
title: "ADR 0007: Four test tiers and an 80% coverage gate"
description: "Unit, component, MSW integration and a Playwright smoke test; line coverage of non-generated code is at least 80%."
tags: [adr, testing, coverage]
status: stable
---
# ADR 0007: Four test tiers and an 80% coverage gate

**Status:** Accepted - 2026-10-19. Mirrors the Flutter stack's tiers. See also [ADR 0017](0017-test-harness.md) (harness, fakes per port, mock-mode e2e) and [ADR 0018](0018-ci-and-runtime-delivery.md) (CI).

## Context
The same slice should be checked at several depths without every test being slow.

## Decision
Vitest unit tests (domain, mappers, repositories, hooks); Testing Library component tests; integration scenarios that run
the real repositories against MSW handlers; one Playwright smoke test against the built app with MSW and no real backend.
Tests use hand-written fakes for repositories, not mock frameworks. Line coverage of non-generated code must be at least 80%. Today the
threshold is enforced locally by `vitest.config.ts` (`coverage.thresholds`, run with `pnpm test:coverage`). The CI gate
runs `pnpm check`, which includes the coverage threshold and `okf.py`, from step 2 of the
bootstrap plan; the e2e script (`pnpm e2e`, not part of `pnpm check`) is built in step 9 and its CI job added in step 12. The e2e job runs after the build
and is required on pull requests to `main`.

## Consequences
**Good.** Fast feedback at the bottom, one real browser check at the top.
**Costly.** MSW handlers need upkeep when the contract changes; Playwright adds CI time and a browser download.
**Alternatives rejected.** Mock-heavy tests: they pin implementation, not behaviour. E2E against a real backend: none exists here.

## When to revisit
When the real .NET API is reachable from CI, or if the threshold blocks useful changes.
