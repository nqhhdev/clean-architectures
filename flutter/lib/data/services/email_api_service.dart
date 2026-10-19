import 'package:clean_architecture/data/services/api_client.dart';
import 'package:clean_architecture/data/services/api_exception.dart';
import 'package:clean_architecture/data/services/model/email_dto.dart';

/// Stateless wrapper over the emails REST API. Returns wire models (DTOs);
/// mapping to the domain, and what to do with an invalid item, is the
/// repository's job.
class EmailApiService {
  const EmailApiService(this._api);

  final ApiClient _api;

  Future<List<EmailDto>> getEmails() async {
    final body = await _api.getJson('/emails');
    if (body is! List<Object?>) {
      throw ApiException(
        ApiFailure.malformed,
        message: 'expected a JSON array',
        cause: FormatException(
          'expected a JSON array, got ${body.runtimeType}',
        ),
        stackTrace: StackTrace.current,
      );
    }
    return [for (final item in body) _parse(item)];
  }

  Future<void> setRead(String id, {required bool isRead}) =>
      _api.patchJson('/emails/${Uri.encodeComponent(id)}', {'isRead': isRead});

  Future<void> delete(String id) =>
      _api.delete('/emails/${Uri.encodeComponent(id)}');

  /// Wrong-typed or missing fields must never escape `data/` as a raw
  /// exception: they become `ApiFailure.malformed`.
  EmailDto _parse(Object? json) {
    try {
      return EmailDto.fromJson(json! as Map<String, dynamic>);
    } on Object catch (e, s) {
      throw ApiException(
        ApiFailure.malformed,
        message: 'invalid email item',
        cause: e,
        stackTrace: s,
      );
    }
  }
}
