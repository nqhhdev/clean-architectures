import 'dart:convert';
import 'dart:io';

import 'package:clean_architecture/domain/errors/email_errors.dart';
import 'package:clean_architecture/ui/core/l10n/error_localizations.dart';
import 'package:clean_architecture/ui/core/l10n/generated/app_localizations.dart';
import 'package:clean_architecture/utils/common_errors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every error code has a localized message in every locale', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      for (final error in [...CommonErrors.all, ...EmailErrors.all]) {
        if (error == CommonErrors.unknown) continue;
        expect(
          l10n.errorMessage(error),
          isNot(l10n.errorCommonUnknown),
          reason: '${error.code} is not localized in ${locale.languageCode}',
        );
      }
    }
  });

  test('all ARB files have the same keys', () {
    Set<String> keys(String file) =>
        (jsonDecode(File('lib/ui/core/l10n/$file').readAsStringSync())
                as Map<String, dynamic>)
            .keys
            .where((k) => !k.startsWith('@'))
            .toSet();
    for (final locale in AppLocalizations.supportedLocales) {
      expect(keys('app_${locale.languageCode}.arb'), keys('app_en.arb'));
    }
  });
}
