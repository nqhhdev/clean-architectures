import 'package:clean_architecture/utils/logger.dart';
import 'package:flutter/foundation.dart';

/// Routes every error that escapes the app to [reporter]:
/// framework errors (`FlutterError.onError`) and uncaught async/platform errors
/// (`PlatformDispatcher.onError`). Call once from `main`, before `runApp`.
/// `ErrorWidget.builder` is set in `main` because it builds a widget.
void installErrorHooks(CrashReporter reporter) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    reporter.recordError(details.exception, details.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    reporter.recordError(error, stack, fatal: true);
    return true;
  };
}
