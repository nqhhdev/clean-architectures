import 'package:clean_architecture/utils/error.dart';

/// Errors every feature can produce. Feature-specific ones (for example an
/// invalid id) live in `domain/errors/<feature>_errors.dart`.
abstract final class CommonErrors {
  static const network = AppError('Common.Network', ErrorType.network);
  static const unauthorized = AppError(
    'Common.Unauthorized',
    ErrorType.unauthorized,
  );
  static const conflict = AppError('Common.Conflict', ErrorType.conflict);
  static const validation = AppError('Common.Validation', ErrorType.validation);
  static const server = AppError('Common.Server', ErrorType.failure);
  static const unknown = AppError('Common.Unknown', ErrorType.failure);

  /// Every common error, so the UI can verify it localizes all of them.
  static const List<AppError> all = [
    network,
    unauthorized,
    conflict,
    validation,
    server,
    unknown,
  ];
}
