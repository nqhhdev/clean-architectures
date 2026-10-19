import 'package:clean_architecture/config/app_status.dart';
import 'package:clean_architecture/config/env.dart';
import 'package:clean_architecture/config/logging.dart';
import 'package:clean_architecture/data/services/api_client.dart';
import 'package:clean_architecture/utils/error.dart';
import 'package:clean_architecture/utils/logger.dart';
import 'package:clean_architecture/utils/urgent_failure_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Cross-cutting providers. Feature providers live next to this file in
/// `<feature>_providers.dart`. Tests override these with `ProviderScope`.

/// Overridden in `main` with the resolved configuration.
final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final loggerProvider = Provider<Logger>((ref) => const ConsoleLogger());

final crashReporterProvider = Provider<CrashReporter>(
  (ref) => LoggingCrashReporter(ref.watch(loggerProvider)),
);

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final urgentFailureHandlerProvider = Provider<UrgentFailureHandler>(
  (ref) => AppStatusFailureHandler(ref.watch(appStatusProvider.notifier)),
);

/// Where the bearer token comes from. Returns null until a real sign-in flow
/// exists; replace it with a secure-storage read.
final authTokenSourceProvider = Provider<AuthTokenProvider>(
  (ref) =>
      () async => null,
);

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    client: ref.watch(httpClientProvider),
    baseUrl: ref.watch(appConfigProvider).apiBaseUrl,
    tokenProvider: ref.watch(authTokenSourceProvider),
    logger: ref.watch(loggerProvider),
    // A real HTTP response proves the network works; a 2xx also proves the
    // session is valid. Each clears only its own failure type (ADR 0019).
    onResponse: (status) {
      final handler = ref.read(urgentFailureHandlerProvider)
        ..clear(ErrorType.network);
      if (status >= 200 && status < 300) handler.clear(ErrorType.unauthorized);
    },
  );
});
