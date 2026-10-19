import 'dart:async';
import 'dart:convert';

import 'package:clean_architecture/data/services/api_exception.dart';
import 'package:clean_architecture/utils/logger.dart';
import 'package:http/http.dart' as http;

/// Supplies the bearer token for authenticated requests, or null when signed
/// out.
typedef AuthTokenProvider = Future<String?> Function();

/// Told about every HTTP response (any status). Proves the server was reached.
typedef ResponseObserver = void Function(int statusCode);

/// Delay before retry number `attempt` (1-based).
typedef RetryDelay = Duration Function(int attempt);

/// Shared HTTP plumbing for every feature service: base URL, default headers,
/// auth token, timeout, retry of idempotent requests, logging and status
/// mapping. Services call [getJson], [patchJson] and [delete]; they never
/// touch `package:http` directly. Holds no state besides its configuration.
class ApiClient {
  ApiClient({
    required http.Client client,
    required Uri baseUrl,
    AuthTokenProvider? tokenProvider,
    Logger? logger,
    ResponseObserver? onResponse,
    Duration timeout = const Duration(seconds: 10),
    int maxAttempts = 3,
    RetryDelay? retryDelay,
    Future<void> Function(Duration)? sleep,
    Map<String, String> defaultHeaders = const {},
  }) : _client = client,
       _baseUrl = baseUrl,
       _tokenProvider = tokenProvider,
       _logger = logger,
       _onResponse = onResponse,
       _timeout = timeout,
       _maxAttempts = maxAttempts,
       _retryDelay = retryDelay ?? _exponentialBackoff,
       _sleep = sleep ?? Future<void>.delayed,
       _defaultHeaders = defaultHeaders;

  final http.Client _client;
  final Uri _baseUrl;
  final AuthTokenProvider? _tokenProvider;
  final Logger? _logger;
  final ResponseObserver? _onResponse;
  final Duration _timeout;
  final int _maxAttempts;
  final RetryDelay _retryDelay;
  final Future<void> Function(Duration) _sleep;
  final Map<String, String> _defaultHeaders;

  static Duration _exponentialBackoff(int attempt) =>
      Duration(milliseconds: 200 * (1 << (attempt - 1)));

  /// GET [path] and decode the JSON body. Retried on transient failures.
  Future<Object?> getJson(String path) async {
    final response = await _send('GET', path, retry: true);
    try {
      return jsonDecode(response.body);
    } on FormatException catch (e, s) {
      throw ApiException(
        ApiFailure.malformed,
        message: 'body is not JSON',
        statusCode: response.statusCode,
        cause: e,
        stackTrace: s,
      );
    }
  }

  /// PATCH [path] with a JSON [body]. Not retried (not idempotent by default).
  Future<void> patchJson(String path, Object body) async {
    await _send('PATCH', path, body: body);
  }

  /// DELETE [path]. Retried on transient failures.
  Future<void> delete(String path) async {
    await _send('DELETE', path, retry: true);
  }

  Uri _uri(String path) => _baseUrl.replace(
    path: '${_baseUrl.path.replaceAll(RegExp(r'/+$'), '')}$path',
  );

  Future<Map<String, String>> _headers({required bool hasBody}) async {
    final token = await _tokenProvider?.call();
    return {
      'accept': 'application/json',
      if (hasBody) 'content-type': 'application/json',
      ..._defaultHeaders,
      if (token != null) 'authorization': 'Bearer $token',
    };
  }

  Future<http.Response> _send(
    String method,
    String path, {
    Object? body,
    bool retry = false,
  }) async {
    final attempts = retry ? _maxAttempts : 1;
    for (var attempt = 1; ; attempt++) {
      try {
        return await _sendOnce(method, path, body);
      } on ApiException catch (e) {
        final transient =
            e.failure == ApiFailure.network ||
            (e.failure == ApiFailure.server && _isGatewayError(e.statusCode));
        if (!transient || attempt >= attempts) rethrow;
        _logger?.warning(
          '$method $path failed (${e.failure.name}); '
          'retry $attempt/${attempts - 1}',
        );
        await _sleep(_retryDelay(attempt));
      }
    }
  }

  bool _isGatewayError(int? status) =>
      status == 502 || status == 503 || status == 504;

  Future<http.Response> _sendOnce(
    String method,
    String path,
    Object? body,
  ) async {
    final request = http.Request(method, _uri(path))
      ..headers.addAll(await _headers(hasBody: body != null));
    if (body != null) request.body = jsonEncode(body);

    final stopwatch = Stopwatch()..start();
    final http.Response response;
    try {
      response = await http.Response.fromStream(
        await _client.send(request).timeout(_timeout),
      ).timeout(_timeout);
    } on TimeoutException catch (e, s) {
      _logger?.warning('$method $path timed out');
      throw ApiException(
        ApiFailure.network,
        message: 'timeout',
        cause: e,
        stackTrace: s,
      );
    } on http.ClientException catch (e, s) {
      _logger?.warning('$method $path unreachable: ${e.message}');
      throw ApiException(
        ApiFailure.network,
        message: e.message,
        cause: e,
        stackTrace: s,
      );
    }

    final status = response.statusCode;
    _logger?.debug(
      '$method $path -> $status (${stopwatch.elapsedMilliseconds} ms)',
    );
    _onResponse?.call(status);
    if (status >= 200 && status < 300) return response;
    throw ApiException(_failureFor(status), statusCode: status);
  }

  /// Status mapping shared by every service.
  static ApiFailure _failureFor(int status) => switch (status) {
    401 || 403 => ApiFailure.unauthorized,
    404 => ApiFailure.notFound,
    409 => ApiFailure.conflict,
    400 || 422 => ApiFailure.validation,
    >= 500 => ApiFailure.server,
    _ => ApiFailure.unknown,
  };
}
