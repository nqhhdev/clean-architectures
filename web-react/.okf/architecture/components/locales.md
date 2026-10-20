---
type: Component
title: "Locales layer"
description: "C4 level 3 - src/locales/: en.json, the single source of translation keys; only app/ and tests import it."
resource: src/locales/en.json
tags: [c4, components, i18n, locales]
status: draft
---
# Locales layer

`src/locales/en.json` is the only locale file today. `app/i18n.ts` imports it and derives the `TranslationKey` type from
it, so a misspelt key is a compile error ([ADR 0015](../../adr/0015-i18n-keys-from-en-json.md)). Only `app/` and tests
may import `locales/` (K20); features and `ds/` use `useTranslation()` or receive translated props.

Top-level groups: `app`, `nav`, `signIn`, `notFound`, `errors` (`title`, `retry`, one key per `AppErrorKind`,
`unexpected`) and `emails`. `errors.<kind>` is the key `errorKey()` returns.

Any further `src/locales/*.json` must have exactly the keys of `en.json`; `src/app/i18n.test.ts` checks this.
