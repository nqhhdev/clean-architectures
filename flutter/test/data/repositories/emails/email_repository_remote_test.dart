import 'package:clean_architecture/data/repositories/emails/email_repository_remote.dart';
import 'package:clean_architecture/data/services/api_exception.dart';
import 'package:clean_architecture/domain/errors/email_errors.dart';
import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/utils/common_errors.dart';
import 'package:clean_architecture/utils/error.dart';
import 'package:clean_architecture/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/builders.dart';
import '../../../support/fakes.dart';

void main() {
  late FakeEmailApiService api;
  late RecordingLogger logger;
  late EmailRepositoryRemote repo;

  setUp(() {
    api = FakeEmailApiService()..dtos = [buildDto('1'), buildDto('2')];
    logger = RecordingLogger();
    repo = EmailRepositoryRemote(api, logger);
  });

  List<Email> ok(Result<List<Email>> r) => (r as Success<List<Email>>).value;
  AppError err<T>(Result<T> r) => (r as Failure<T>).error;

  test('reads are cache-first; forceRefresh refetches', () async {
    await repo.getAll();
    await repo.getAll();
    expect(api.getCalls, 1);
    api.dtos = [buildDto('3')];
    expect(ok(await repo.getAll(forceRefresh: true)).single.id, '3');
  });

  test('a failed refresh reports the error and keeps the old cache', () async {
    await repo.getAll();
    api.failure = const ApiException(ApiFailure.network);
    expect(err(await repo.getAll(forceRefresh: true)), CommonErrors.network);
    expect(ok(await repo.getAll()), hasLength(2));
  });

  test(
    'an invalid item is skipped and logged, the rest is kept (ADR 0018)',
    () async {
      api.dtos = [buildDto('1'), buildDto(' '), buildDto('3')];
      expect(ok(await repo.getAll()).map((e) => e.id), ['1', '3']);
      expect(logger.text, contains(EmailErrors.invalidId.code));
    },
  );

  test('service failures become coded errors that keep the cause', () async {
    for (final (failure, expected) in [
      (ApiFailure.network, CommonErrors.network),
      (ApiFailure.unauthorized, CommonErrors.unauthorized),
      (ApiFailure.conflict, CommonErrors.conflict),
      (ApiFailure.malformed, CommonErrors.server),
      (ApiFailure.notFound, EmailErrors.notFound),
    ]) {
      api.failure = ApiException(failure);
      final error = err(await EmailRepositoryRemote(api).getAll());
      expect(error, expected, reason: failure.name);
      expect(error.cause, isA<ApiException>());
    }
  });

  test('a successful write refetches; a failed write does not', () async {
    await repo.getAll();
    await repo.delete('1');
    expect(ok(await repo.getAll()).map((e) => e.id), ['2']);
    expect(api.getCalls, 2);

    api.failure = const ApiException(ApiFailure.unauthorized);
    expect(
      err(await repo.setRead('2', isRead: true)),
      CommonErrors.unauthorized,
    );
    expect(api.getCalls, 2);
  });
}
