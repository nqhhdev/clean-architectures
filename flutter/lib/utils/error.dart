import 'package:meta/meta.dart';

/// How an [AppError] should be treated by callers.
enum ErrorType {
  /// Input was rejected (bad value, HTTP 400/422).
  validation,

  /// The thing asked for does not exist.
  notFound,

  /// The request conflicts with current state (HTTP 409).
  conflict,

  /// The server failed or answered something unusable.
  failure,

  /// The session is no longer valid; the user must sign in again.
  unauthorized,

  /// The server could not be reached.
  network,
}

/// A named, typed failure. Codes follow `Feature.Reason`, e.g.
/// `Emails.InvalidId`. There is deliberately no human-readable message: the UI
/// maps [code] to a localized string, and [cause] / [stackTrace] are for logs.
@immutable
class AppError implements Exception {
  const AppError(this.code, this.type, {this.cause, this.stackTrace});

  final String code;
  final ErrorType type;

  /// The underlying exception, if any. Never shown to users.
  final Object? cause;
  final StackTrace? stackTrace;

  /// The same error with a cause attached (for logging and crash reports).
  AppError withCause(Object? cause, [StackTrace? stackTrace]) => AppError(
    code,
    type,
    cause: cause,
    stackTrace: stackTrace,
  );

  /// Equal when code and type match; cause and stack are diagnostics only.
  @override
  bool operator ==(Object other) =>
      other is AppError && other.code == code && other.type == type;

  @override
  int get hashCode => Object.hash(code, type);

  @override
  String toString() {
    final withCause = cause == null ? '' : ', cause: $cause';
    return 'AppError($code, ${type.name}$withCause)';
  }
}
