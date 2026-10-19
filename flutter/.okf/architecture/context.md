---
type: System Context
title: "System Context"
description: "C4 level 1 - what this app is, who uses it, and which external systems it depends on."
resource: pubspec.yaml
tags: [c4, context, flutter]
status: stable
---
# System Context

## The system
A **Flutter mobile app** (iOS and Android) built as a clean-architecture starter: the official Flutter layers,
Riverpod for DI and state, and structural rules enforced by tests. It is a template: the business capability is
yours to add. What exists is the machinery plus one example slice, the [Emails](../domains/emails/emails.md) inbox.

## Who uses it
| Actor | Interaction |
|---|---|
| **End user** | Uses the [Flutter app](../architecture/containers/app/flutter-app.md) on a phone |
| **Developer** | Builds on the starter; reads this bundle first |

## External systems
| System | Role | Status |
|---|---|---|
| **Backend REST API** | Source of truth for emails, see [API Surface](../architecture/cross-cutting/api-surface.md) | Not in this repo. Stand-in: [Mock Email API](../architecture/containers/mock-api/mock-email-api.md) |
| **Identity provider** | Issues and refreshes sessions | Not implemented, see [Security](../architecture/cross-cutting/security-and-authorization.md) |
| **Crash / log monitoring** | Receives error-level logs | Not implemented, see [Observability](../architecture/cross-cutting/observability.md) |

## Boundaries
Everything under `flutter/` is this system. Other stacks in the monorepo have their own folders and bundles.
