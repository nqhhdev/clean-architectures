---
type: ADR
title: "ADR 0015: Localize with gen-l10n; errors carry codes and the UI maps them to text"
description: "All user-facing text comes from ARB files via gen-l10n; AppError codes are localized in one UI extension."
tags: [adr, l10n, errors, ui]
status: stable
---
# ADR 0015: Localize with gen-l10n; errors carry codes and the UI maps them to text

**Status:** Accepted - 2026-10-19.

## Context
Strings were hard-coded in widgets and error values carried English descriptions, so lower layers decided user-facing text.

## Decision
* ARB files in [`lib/ui/core/l10n/`](../../lib/ui/core/l10n/app_en.arb) (`app_en.arb` template, `app_vi.arb`); [`l10n.yaml`](../../l10n.yaml)
  generates `AppLocalizations` into `lib/ui/core/l10n/generated/` (git-ignored, rebuilt by `flutter pub get`).
* [`AppError`](../../lib/utils/error.dart) has a `code` and `type`, no message. The UI calls `l10n.errorMessage(error)` from
  [`error_localizations.dart`](../../lib/ui/core/l10n/error_localizations.dart); unknown codes fall back to `errorCommonUnknown`.
* Exception: [`buildErrorWidget`](../../lib/ui/core/error_widget.dart) may run outside `Localizations` and uses fixed English.

## Consequences
**Good.** Domain and data stay text-free; [`l10n_test.dart`](../../test/ui/core/l10n_test.dart) fails when a code in `CommonErrors.all`
or a feature's `all` list lacks a message, or ARB keys differ between locales.
**Costly.** Every new error code needs an ARB entry per locale and a switch arm.
**Alternatives rejected.** Messages inside `AppError` (not localizable); `easy_localization` or similar packages (gen-l10n ships with the SDK).

## When to revisit
When translations move to an external service that needs another file format.
