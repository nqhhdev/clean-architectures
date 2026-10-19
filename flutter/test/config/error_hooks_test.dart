import 'dart:ui';

import 'package:clean_architecture/config/error_hooks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';

void main() {
  late FlutterExceptionHandler? originalFlutterHook;
  late ErrorCallback? originalPlatformHook;

  setUp(() {
    originalFlutterHook = FlutterError.onError;
    originalPlatformHook = PlatformDispatcher.instance.onError;
  });

  tearDown(() {
    FlutterError.onError = originalFlutterHook;
    PlatformDispatcher.instance.onError = originalPlatformHook;
  });

  test('framework errors reach the crash reporter as non-fatal', () {
    final reporter = RecordingCrashReporter();
    installErrorHooks(reporter);
    final error = StateError('widget failed');

    // Do not print the framework dump into test output.
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) {};
    addTearDown(() => debugPrint = original);

    FlutterError.onError!(FlutterErrorDetails(exception: error));

    expect(reporter.errors, [(error, false)]);
  });

  test(
    'uncaught platform errors reach the reporter as fatal and are handled',
    () {
      final reporter = RecordingCrashReporter();
      installErrorHooks(reporter);
      final error = Exception('async failure');

      final handled = PlatformDispatcher.instance.onError!(
        error,
        StackTrace.current,
      );

      expect(handled, isTrue);
      expect(reporter.errors, [(error, true)]);
    },
  );
}
