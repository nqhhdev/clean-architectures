import 'package:flutter/foundation.dart';

/// Deployment environment. Selected with `--dart-define=ENV=...`, normally via
/// `--dart-define-from-file=env/<name>.json`.
enum AppEnvironment { dev, stg, prod }

/// A required setting is missing or invalid. Thrown at startup so a release
/// build never runs against a wrong or default server.
class ConfigurationError implements Exception {
  const ConfigurationError(this.message);

  final String message;

  @override
  String toString() => 'ConfigurationError: $message';
}

/// Immutable build-time configuration, read once in `main`, never from
/// widgets.
@immutable
class AppConfig {
  const AppConfig({required this.environment, required this.apiBaseUrl});

  /// Reads `ENV` and `API_BASE_URL` from `--dart-define`.
  factory AppConfig.fromEnvironment() => AppConfig.resolve(
    env: const String.fromEnvironment('ENV'),
    apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
    isRelease: kReleaseMode,
  );

  /// Pure resolution so it can be tested. In debug and profile builds, missing
  /// values fall back to a local dev server; in release they fail fast.
  factory AppConfig.resolve({
    required String env,
    required String apiBaseUrl,
    required bool isRelease,
  }) {
    final environment = _parseEnvironment(env, isRelease: isRelease);
    final raw = apiBaseUrl.trim();
    if (raw.isEmpty) {
      if (isRelease) {
        throw const ConfigurationError(
          'API_BASE_URL is missing. Build with '
          '--dart-define-from-file=env/<dev|stg|prod>.json.',
        );
      }
      return AppConfig(
        environment: environment,
        apiBaseUrl: Uri.parse(debugDefaultBaseUrl),
      );
    }
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw ConfigurationError('API_BASE_URL is not an absolute URL: "$raw".');
    }
    if (environment == AppEnvironment.prod && uri.scheme != 'https') {
      throw const ConfigurationError('API_BASE_URL must be https in prod.');
    }
    return AppConfig(environment: environment, apiBaseUrl: uri);
  }

  /// Used only when `API_BASE_URL` is absent in a non-release build.
  static const debugDefaultBaseUrl = 'http://127.0.0.1:8080';

  final AppEnvironment environment;
  final Uri apiBaseUrl;

  static AppEnvironment _parseEnvironment(
    String env, {
    required bool isRelease,
  }) {
    if (env.isEmpty) {
      if (isRelease) throw const ConfigurationError('ENV is missing.');
      return AppEnvironment.dev;
    }
    for (final candidate in AppEnvironment.values) {
      if (candidate.name == env) return candidate;
    }
    throw ConfigurationError('ENV must be dev, stg or prod, got "$env".');
  }
}
