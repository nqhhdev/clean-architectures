/// Severity levels; see the Logging convention in `.okf`.
enum LogLevel { trace, debug, info, warning, error, critical }

/// Logging port. Implemented in `config/`; used from any layer.
// A port stays an interface (not a typedef) so config/ can swap implementations.
// ignore: one_member_abstracts
abstract interface class Logger {
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}

/// Crash/error reporting port (Sentry, Crashlytics, ...). Implemented in
/// `config/`.
// A port stays an interface (not a typedef) so config/ can swap implementations.
// ignore: one_member_abstracts
abstract interface class CrashReporter {
  /// [fatal] is true for errors that escaped every handler.
  void recordError(Object error, StackTrace? stackTrace, {bool fatal = false});
}

/// Convenience calls so call sites stay short.
extension LoggerShortcuts on Logger {
  void debug(String message) => log(LogLevel.debug, message);
  void info(String message) => log(LogLevel.info, message);
  void warning(String message, {Object? error, StackTrace? stackTrace}) =>
      log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      log(LogLevel.error, message, error: error, stackTrace: stackTrace);
}
