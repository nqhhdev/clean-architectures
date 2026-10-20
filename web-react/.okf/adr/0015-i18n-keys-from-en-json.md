---
type: ADR
title: "ADR 0015: Translation keys are derived from en.json; locales live in src/locales/"
description: "en.json is the source, TranslationKey is derived from it so a missing key is a type error, and a test checks key parity across locales."
tags: [adr, i18n, locales]
status: stable
---
# ADR 0015: Translation keys are derived from en.json; locales live in src/locales/

**Status:** Accepted - 2026-10-19.

## Context
User-visible text and error messages need translation, and a typo in a key should fail the build, not show a raw key.
Locale files are data, not a layer of [ADR 0010](0010-hexagonal-layers-boundaries-and-services.md).

## Decision
* Locale JSON lives in `src/locales/`. Only `app/` (i18n set-up) and tests import it.
* `en.json` is the source. `TranslationKey` is derived from it through i18next resource type augmentation (or `keyof`
  of the imported JSON), so features get typed keys without importing `locales/`.
* A test checks that every other locale has exactly the keys of `en.json`, in both directions.
* One pure helper maps an `AppError` ([ADR 0012](0012-result-and-app-error.md)) to a key: `errors.<kind>`, with
  `errors.<kind>.<code>` when a code exists. Every screen uses it.
* User-visible strings in `features/` come from keys. `ds/` takes already-translated props.

**Built in step 7.** `app/i18n.ts` creates one i18next instance per app and augments `CustomTypeOptions` from `en.json`; `application/error-key.ts` holds the pure helper. JSON cannot hold both a string and an object at `errors.<kind>`, so the per-code key `errors.<kind>.<code>` is not built: the helper returns `errors.<kind>` only until the API publishes codes (decided by builder, awaiting owner review).

## Consequences
**Good.** Missing keys are type errors; locales cannot drift silently; one place maps errors to text.
**Costly.** Type augmentation is global and a little magic; every new string touches `en.json`.
**Alternatives rejected.** Untyped string keys: typos reach users. A separate extraction tool: one more build step.

## When to revisit
When translators need a platform that dictates another file format, or the key set is too large for one JSON file per locale.
