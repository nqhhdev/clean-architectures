---
type: Mechanism
title: "Security and Authorization"
description: "The universal security baseline and its current state, plus project-specific choices each project must fill in."
tags: [security, auth]
status: draft
---
# Security and Authorization

> **Draft** until the baseline is enforced and the project-specific table is filled. Rules: [ADR 0020](../../adr/0020-security-baseline.md),
> rows S1-S7 in [Constraints](../../engineering/constraints.md); work: [backlog](../../backlog/security-baseline-enforcement.md).

## Baseline (universal)
| Rule | State in this template | Evidence |
|---|---|---|
| S1 no secrets | `env/*.json` hold only `ENV`, `API_BASE_URL`; no scanner | [`env/`](../../../env/prod.json) |
| S2 https / cleartext | prod https checked at startup, stg not; cleartext only in the debug manifest; no test | [`env.dart`](../../../lib/config/env.dart), [debug manifest](../../../android/app/src/debug/AndroidManifest.xml) |
| S3 SecureStore | no port, no token storage; `authTokenSourceProvider` returns null | [`core_providers.dart`](../../../lib/config/providers/core_providers.dart) |
| S4 redacting Logger | `ConsoleLogger` does not redact | [`logging.dart`](../../../lib/config/logging.dart) |
| S5 obfuscated release | no release build step | [CI Pipeline](../delivery/ci-pipeline.md) |
| S6 vulnerable deps | Dependabot version updates only; nothing blocks merge | [CI Pipeline](../delivery/ci-pipeline.md) |
| S7 no body logs | `ApiClient` logs method, path, status, duration; no test | [`api_client.dart`](../../../lib/data/services/api_client.dart) |

Auth plumbing: `ApiClient` sends `authorization: Bearer <token>` when `AuthTokenProvider` returns one; a 401/403 redirects to the
placeholder sign-in ([Navigation](navigation.md), [ADR 0017](../../adr/0017-routing-go-router.md)).

## Project-specific (fill in per project; `onboard-repo` gate)
| Item | Decision |
|---|---|
| Identity provider | Unverified: TBD per project ([backlog](../../backlog/real-auth-flow.md)) |
| Refresh token | Unverified: TBD per project |
| Certificate pinning | Unverified: TBD per project |
| Release signing | Unverified: TBD per project ([Infrastructure](../delivery/infrastructure.md)) |
| Jailbreak / root detection | Unverified: TBD per project |
| Deep-link allowlist | Unverified: TBD per project ([Route Conventions](../../engineering/conventions/route-conventions.md)) |
