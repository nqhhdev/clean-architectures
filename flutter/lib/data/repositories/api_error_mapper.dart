import 'package:clean_architecture/data/services/api_exception.dart';
import 'package:clean_architecture/utils/common_errors.dart';
import 'package:clean_architecture/utils/error.dart';

/// Turns a service failure into an [AppError], keeping the cause for logs.
/// [notFound] lets a feature say which error a 404 means for it.
AppError appErrorFromApi(ApiException e, {AppError? notFound}) {
  final base = switch (e.failure) {
    ApiFailure.network => CommonErrors.network,
    ApiFailure.unauthorized => CommonErrors.unauthorized,
    ApiFailure.notFound => notFound ?? CommonErrors.unknown,
    ApiFailure.conflict => CommonErrors.conflict,
    ApiFailure.validation => CommonErrors.validation,
    ApiFailure.server || ApiFailure.malformed => CommonErrors.server,
    ApiFailure.unknown => CommonErrors.unknown,
  };
  return base.withCause(e, e.stackTrace);
}
