import 'package:clean_architecture/app.dart';
import 'package:clean_architecture/config/env.dart';
import 'package:clean_architecture/config/error_hooks.dart';
import 'package:clean_architecture/config/logging.dart';
import 'package:clean_architecture/config/providers/core_providers.dart';
import 'package:clean_architecture/ui/core/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Entry point: resolve configuration (fails fast in release if it is
/// incomplete), install global error hooks, then start the app.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  const logger = ConsoleLogger();
  const reporter = LoggingCrashReporter(logger);

  installErrorHooks(reporter);
  ErrorWidget.builder = buildErrorWidget;

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        loggerProvider.overrideWithValue(logger),
        crashReporterProvider.overrideWithValue(reporter),
      ],
      child: const App(),
    ),
  );
}
