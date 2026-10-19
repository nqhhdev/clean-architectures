---
type: ADR
title: "ADR 0010: Optional use-case layer in domain/use_cases"
description: "Screen logic that sorts, combines or is shared lives in use-case classes between repositories and ViewModels."
tags: [adr, architecture, layers, use-cases]
status: stable
---
# ADR 0010: Optional use-case layer in domain/use_cases

**Status:** Accepted - 2026-10-19. Builds on [ADR 0001](0001-flutter-app-architecture-layers.md), which left use cases optional.

## Context
The official guide makes the domain layer optional. Logic such as "newest first" sat in the ViewModel, so it could only be
tested through Riverpod, and a second screen needing it would copy it.

## Decision
* `lib/domain/use_cases/` holds one class per use case, `<Verb><Noun>UseCase` in `<verb>_<noun>_use_case.dart`, with a `call(...)` method.
* A use case may import `domain`, `utils` and `data/repositories` (interfaces only); `config` and `ui` may import it.
* Providers live in `config/providers/<feature>_providers.dart`; ViewModels read them.
* Examples: [`ListEmailsUseCase`](../../lib/domain/use_cases/list_emails_use_case.dart) (sorts newest first),
  [`ToggleEmailReadUseCase`](../../lib/domain/use_cases/toggle_email_read_use_case.dart),
  [`DeleteEmailUseCase`](../../lib/domain/use_cases/delete_email_use_case.dart).
* Enforced by `allowedImports` and the naming rules in [`layer_rules.dart`](../../test/architecture/layer_rules.dart).

## Consequences
**Good.** Logic is plain Dart, tested without widgets or providers
([`email_use_cases_test.dart`](../../test/domain/use_cases/email_use_cases_test.dart)).
**Costly.** One more file and provider per action; the toggle and delete use cases are pass-throughs.
**Alternatives rejected.** Logic in the ViewModel (not reusable); use cases over services (would bypass the repository cache, [ADR 0006](0006-ui-reads-from-repository-cache.md)).

## When to revisit
If most use cases stay pass-throughs, let ViewModels call repositories directly again.
