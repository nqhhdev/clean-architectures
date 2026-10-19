---
type: ADR
title: "ADR 0011: Generate models with freezed and json_serializable, keep output git-ignored"
description: "Models, state and DTOs use freezed; DTOs parse with checked json_serializable; generated files are rebuilt, never committed."
tags: [adr, codegen, freezed, json]
status: stable
---
# ADR 0011: Generate models with freezed and json_serializable, keep output git-ignored

**Status:** Accepted - 2026-10-19.

## Context
Hand-written `==`, `hashCode`, `copyWith` and `fromJson` drift from the fields. Unchecked JSON casts throw `TypeError`,
an `Error` that escapes `on Exception` handlers.

## Decision
* Domain models, shared state and DTOs are `@freezed abstract class`: [`Email`](../../lib/domain/models/email.dart),
  [`AppStatus`](../../lib/config/app_status.dart), [`EmailDto`](../../lib/data/services/model/email_dto.dart).
* Only DTOs carry JSON. [`build.yaml`](../../build.yaml) sets `checked: true` (wrong types throw `CheckedFromJsonException`) and `explicit_to_json: true`.
* `*.freezed.dart` and `*.g.dart` are git-ignored ([`.gitignore`](../../.gitignore)); run `dart run build_runner build -d`
  after `flutter pub get` and after editing a model. CI does the same.
* Generated files are excluded from the analyzer, the architecture test and the coverage threshold.

## Consequences
**Good.** Value semantics for free; a bad payload becomes `ApiFailure.malformed` ([ADR 0018](0018-data-layer-api-client-dtos-errors.md)).
**Costly.** A fresh clone does not compile until build_runner runs. `copyWith` skips `create` validation.
**Alternatives rejected.** Hand-written boilerplate (drift); committing generated files (noisy diffs, merge conflicts).

## When to revisit
When Dart macros or another generator replace freezed upstream.
