import 'dart:developer' as developer;

import 'package:clean_architecture/utils/logger.dart';
import 'package:flutter/foundation.dart';

/// Writes logs through `dart:developer` so they show in DevTools and the
/// console. Release builds keep warnings and above only.
class ConsoleLogger implements Logger {
  const ConsoleLogger({LogLevel? minimum})
    : _minimum = minimum ?? (kReleaseMode ? LogLevel.warning : LogLevel.debug);

  final LogLevel _minimum;

  @override
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < _minimum.index) return;
    developer.log(
      message,
      name: 'app',
      level: switch (level) {
        LogLevel.trace => 300,
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
        LogLevel.critical => 1200,
      },
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Default [CrashReporter]: logs the error. Replace with a Sentry/Crashlytics
/// implementation in `config/providers/core_providers.dart`.
class LoggingCrashReporter implements CrashReporter {
  const LoggingCrashReporter(this._logger);

  final Logger _logger;

  @override
  void recordError(Object error, StackTrace? stackTrace, {bool fatal = false}) {
    _logger.log(
      fatal ? LogLevel.critical : LogLevel.error,
      fatal ? 'Uncaught error' : 'Reported error',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
