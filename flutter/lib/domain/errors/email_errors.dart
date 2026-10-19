import 'package:clean_architecture/utils/error.dart';

/// Errors specific to the Emails feature. Transport and server problems are
/// `CommonErrors`; the UI localizes every code (no messages here).
abstract final class EmailErrors {
  static const invalidId = AppError('Emails.InvalidId', ErrorType.validation);
  static const notFound = AppError('Emails.NotFound', ErrorType.notFound);

  static const List<AppError> all = [invalidId, notFound];
}
