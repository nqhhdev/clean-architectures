---
type: Mechanism
title: "Localization"
description: "User-facing text comes from ARB files through gen-l10n; error codes are mapped to text in the UI."
resource: l10n.yaml
tags: [l10n, i18n, errors]
status: stable
---
# Localization

| Piece | Where |
|---|---|
| Source strings (`en` template, `vi`) | [`app_en.arb`](../../../lib/ui/core/l10n/app_en.arb), [`app_vi.arb`](../../../lib/ui/core/l10n/app_vi.arb) |
| Generator config | [`l10n.yaml`](../../../l10n.yaml); `generate: true` in [`pubspec.yaml`](../../../pubspec.yaml) |
| Generated `AppLocalizations` | `lib/ui/core/l10n/generated/` (git-ignored; `flutter pub get` rebuilds it) |
| Code to text | `l10n.errorMessage(error)` in [`error_localizations.dart`](../../../lib/ui/core/l10n/error_localizations.dart) |
| Wiring | `localizationsDelegates` / `supportedLocales` in [`app.dart`](../../../lib/app.dart) |

* Widgets read `AppLocalizations.of(context)`; `AppError` carries no text ([Error Codes](../../engineering/conventions/error-codes.md)).
* Unknown codes show `errorCommonUnknown`. [`buildErrorWidget`](../../../lib/ui/core/error_widget.dart) is the one fixed-English exception.
* [`l10n_test.dart`](../../../test/ui/core/l10n_test.dart): every code in `CommonErrors.all` and `EmailErrors.all` has a message in every locale; ARB keys match.

Decision: [ADR 0015](../../adr/0015-localization-gen-l10n.md).
