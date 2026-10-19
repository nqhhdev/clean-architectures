import 'package:clean_architecture/data/repositories/api_error_mapper.dart';
import 'package:clean_architecture/data/repositories/emails/email_mapper.dart';
import 'package:clean_architecture/data/repositories/emails/email_repository.dart';
import 'package:clean_architecture/data/services/api_exception.dart';
import 'package:clean_architecture/data/services/email_api_service.dart';
import 'package:clean_architecture/data/services/model/email_dto.dart';
import 'package:clean_architecture/domain/errors/email_errors.dart';
import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/utils/error.dart';
import 'package:clean_architecture/utils/logger.dart';
import 'package:clean_architecture/utils/result.dart';

/// Cache-first repository over [EmailApiService] (ADR 0006): readers get the
/// cached list; every successful write is followed by a refetch.
///
/// Invalid items: a list endpoint skips (and logs) items that violate domain
/// rules, so one bad row does not hide the rest (ADR 0018). A malformed
/// payload as a whole fails with `Common.Server`.
class EmailRepositoryRemote implements EmailRepository {
  EmailRepositoryRemote(this._api, [this._logger]);

  final EmailApiService _api;
  final Logger? _logger;
  List<Email>? _cache;

  @override
  Future<Result<List<Email>>> getAll({bool forceRefresh = false}) async {
    final cached = _cache;
    if (!forceRefresh && cached != null) return Success(cached);
    return _guard(() async {
      final fresh = List<Email>.unmodifiable(_toDomain(await _api.getEmails()));
      _cache = fresh;
      return fresh;
    });
  }

  @override
  Future<Result<void>> setRead(String id, {required bool isRead}) =>
      _write(() => _api.setRead(id, isRead: isRead));

  @override
  Future<Result<void>> delete(String id) => _write(() => _api.delete(id));

  Iterable<Email> _toDomain(List<EmailDto> dtos) sync* {
    for (final dto in dtos) {
      final result = emailFromDto(dto);
      switch (result) {
        case Success(:final value):
          yield value;
        case Failure(:final error):
          _logger?.warning('Skipped an invalid email: ${error.code}');
      }
    }
  }

  Future<Result<void>> _write(Future<void> Function() write) async {
    final written = await _guard(write);
    if (written case Failure(:final error)) return Failure(error);
    final refreshed = await getAll(forceRefresh: true);
    return refreshed.when(
      success: (_) => const Success(null),
      failure: Failure.new,
    );
  }

  Future<Result<T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Success(await call());
    } on ApiException catch (e) {
      final error = appErrorFromApi(e, notFound: EmailErrors.notFound);
      if (error.type != ErrorType.network) {
        _logger?.error(
          'Email request failed',
          error: e,
          stackTrace: e.stackTrace,
        );
      }
      return Failure(error);
    }
  }
}
