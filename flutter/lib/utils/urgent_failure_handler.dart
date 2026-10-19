import 'package:clean_architecture/utils/error.dart';

/// App-wide reaction to failures no single screen should handle on its own
/// (expired session, no network). See ADR 0004 and ADR 0019.
abstract interface class UrgentFailureHandler {
  /// Returns true when [error] was urgent and has been handled, so the caller
  /// must not show its own error UI.
  bool handle(AppError error);

  /// Clears the urgent state of exactly one failure type. Called by the data
  /// layer after a real network round-trip proves the problem is gone:
  /// [ErrorType.network] when any HTTP response arrives, and
  /// [ErrorType.unauthorized] when an authenticated request succeeds.
  void clear(ErrorType type);
}
