---
type: Task
title: "Security baseline enforcement"
description: "Build the code and CI checks that enforce ADR 0020 rules S1-S7; today they are review-only."
tags: [backlog, security]
status: draft
---
# Security baseline enforcement

**Goal.** Each rule of [ADR 0020](../adr/0020-security-baseline.md) is enforced by a tool, and [Constraints](../engineering/constraints.md) rows S1-S7 name it.

**Non-goals.** Project-specific items (identity provider, pinning, signing, ...); a real sign-in ([Real authentication flow](real-auth-flow.md)).

**C4 impact.** L3: `utils` gains a `SecureStore` port, `config` its implementation and a redacting `Logger`; `test/architecture` a new rule. Delivery: CI and pre-commit steps.

**AC.**
1. Given a committed secret, when CI or the pre-commit hook runs gitleaks, then it fails (S1).
2. Given an `env/stg.json` or `env/prod.json` with http, or `usesCleartextTraffic` outside the debug manifest, when `flutter test` runs, then a test fails (S2).
3. Given a file outside the `SecureStore` implementation importing `shared_preferences` for tokens, when the architecture test runs, then it fails (S3).
4. Given a log message with a token or email address, when it goes through the `Logger`, then the output is redacted (S4).
5. Given a release build in CI, then it uses `--obfuscate --split-debug-info` (S5).
6. Given a dependency with a known vulnerability, then the pull request cannot merge (S6).
7. Given a release `ApiClient`, when a request succeeds or fails, then no body is logged (S7).

**Edge cases.** Redaction must not hide error codes; split debug info must be kept for symbolication.

**Open questions.** What counts as PII for S4; gitleaks allowlist for test fixtures; Dependabot alerts vs `dart pub outdated` for S6.

**Done when** it is built, documented in `.okf/`, and this file is deleted and logged.
