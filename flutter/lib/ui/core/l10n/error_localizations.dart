import 'package:clean_architecture/ui/core/l10n/generated/app_localizations.dart';
import 'package:clean_architecture/utils/error.dart';

/// Maps an [AppError] code to a localized message. Errors carry codes only
/// (ADR 0015); every code a feature can produce needs an entry here, and the
/// l10n test fails when one is missing.
extension AppErrorLocalizations on AppLocalizations {
  String errorMessage(AppError error) => switch (error.code) {
    'Common.Network' => errorCommonNetwork,
    'Common.Unauthorized' => errorCommonUnauthorized,
    'Common.Conflict' => errorCommonConflict,
    'Common.Validation' => errorCommonValidation,
    'Common.Server' => errorCommonServer,
    'Emails.InvalidId' => errorEmailsInvalidId,
    'Emails.NotFound' => errorEmailsNotFound,
    _ => errorCommonUnknown,
  };
}
