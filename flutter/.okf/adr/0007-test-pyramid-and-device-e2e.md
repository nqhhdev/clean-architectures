---
type: ADR
title: "ADR 0007: Four test tiers - unit, widget, headless integration, device e2e"
description: "Test the same slice at four depths, with a shared in-memory mock API for integration and a real HTTP mock server for device e2e."
tags: [adr, testing, e2e]
status: stable
---
# ADR 0007: Four test tiers - unit, widget, headless integration, device e2e

**Status:** Accepted - 2026-10-19.

## Context
Unit tests alone cannot show that screen, ViewModel, repository, service and JSON fit together, and a device e2e
suite alone is slow. tmail-flutter uses Patrol for device e2e with a robot pattern ([Reference](../references/tmail-flutter.md)).

## Decision
See [Test Architecture](../architecture/delivery/test-architecture.md). `test/` runs headless with `flutter test`
(unit, widget, and `test/integration/` against an in-process
[`MockEmailApi`](../../tool/mock_email_api.dart)). `integration_test/` runs on a simulator/device against the real
HTTP [mock server](../../tool/mock_server.dart), driven through robots. Fakes are preferred over mock frameworks.

## Consequences
**Good.** Fast feedback plus one honest full-stack check; the same mock logic serves both.
**Costly.** E2E needs a booted device and a running server. Plain `integration_test` cannot drive native UI or
webviews; Patrol can.
**Alternatives rejected.** Mock frameworks (mocktail/mockito) for repositories: fakes read better and break less.

## When to revisit
When native UI/permissions need testing: adopt Patrol and keep the robots.
