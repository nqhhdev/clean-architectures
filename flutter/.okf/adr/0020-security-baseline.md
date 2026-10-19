---
type: ADR
title: "ADR 0020: A universal security baseline every project built from this template must meet"
description: "Seven security rules apply to every project; project-specific choices stay per project. Enforcement is planned, not built."
tags: [adr, security]
status: stable
---
# ADR 0020: A universal security baseline every project built from this template must meet

**Status:** Accepted - 2026-10-19 (owner). **Enforcement is not implemented yet**: every rule is review-only until
[Security baseline enforcement](../backlog/security-baseline-enforcement.md) lands.

## Context
Security choices were scattered (prod https in [`env.dart`](../../lib/config/env.dart), cleartext only in the
[debug manifest](../../android/app/src/debug/AndroidManifest.xml)) and nothing said which ones a new project may drop.

## Decision
| # | Rule | Planned enforcement |
|---|---|---|
| S1 | No secrets committed; `env/*.json` hold public values only; secrets come from CI or the keychain | gitleaks in CI and pre-commit |
| S2 | stg and prod base URLs are https; cleartext only in debug | test over `env/*.json` and manifests |
| S3 | Tokens only through a `SecureStore` port (interface in `utils/`); never SharedPreferences | `layer_rules.dart` check |
| S4 | Logs never contain PII or tokens; the `Logger` redacts | unit test |
| S5 | Release builds use `--obfuscate --split-debug-info` | CI build step |
| S6 | Vulnerable dependencies block merge | Dependabot alerts / `dart pub outdated` |
| S7 | No request or response body logging in release | `ApiClient` test |

Project-specific (decided per project, recorded in [Security and Authorization](../architecture/cross-cutting/security-and-authorization.md)):
identity provider, refresh token, certificate pinning, release signing, jailbreak/root detection, deep-link allowlist.

## Consequences
**Good.** One list to review against ([Constraints](../engineering/constraints.md)); onboarding audits it.
**Costly.** Until enforcement lands, compliance depends on review. S3 and S4 need code that does not exist yet.
**Alternatives rejected.** Leaving security per project (no floor); a full threat model in the template (project-specific).

## When to revisit
When the enforcement task is done (update the table), or when a rule blocks a legitimate project.
