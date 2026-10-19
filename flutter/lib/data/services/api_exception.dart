/// Why a request failed, as far as the data layer can tell.
enum ApiFailure {
  network,
  unauthorized,
  notFound,
  conflict,
  validation,
  server,
  malformed,
  unknown,
}

/// Thrown by services for transport and protocol problems. Repositories turn
/// it into a `Result`; nothing above `data/` ever sees it. Keeps the original
/// [cause] and [stackTrace] for logs and crash reports.
class ApiException implements Exception {
  const ApiException(
    this.failure, {
    this.message = '',
    this.statusCode,
    this.cause,
    this.stackTrace,
  });

  final ApiFailure failure;
  final String message;
  final int? statusCode;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'ApiException(${failure.name}${statusCode == null ? '' : ' $statusCode'}'
      '${message.isEmpty ? '' : ': $message'})';
}
