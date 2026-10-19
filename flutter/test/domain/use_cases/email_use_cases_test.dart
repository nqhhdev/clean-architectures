import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/domain/use_cases/delete_email_use_case.dart';
import 'package:clean_architecture/domain/use_cases/list_emails_use_case.dart';
import 'package:clean_architecture/domain/use_cases/toggle_email_read_use_case.dart';
import 'package:clean_architecture/utils/common_errors.dart';
import 'package:clean_architecture/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders.dart';
import '../../support/fakes.dart';

void main() {
  late FakeEmailRepository repo;

  setUp(() => repo = FakeEmailRepository());

  group('ListEmailsUseCase', () {
    test('returns the inbox newest first', () async {
      repo.emails = [
        buildEmail('old', receivedAt: DateTime.utc(2026)),
        buildEmail('new', receivedAt: DateTime.utc(2026, 1, 3)),
        buildEmail('mid', receivedAt: DateTime.utc(2026, 1, 2)),
      ];
      final result = await ListEmailsUseCase(repo)();
      expect(
        (result as Success<List<Email>>).value.map((e) => e.id),
        ['new', 'mid', 'old'],
      );
    });

    test('propagates a failure unchanged', () async {
      repo.failure = CommonErrors.network;
      final result = await ListEmailsUseCase(repo)();
      expect((result as Failure).error, CommonErrors.network);
    });
  });

  test('ToggleEmailReadUseCase flips read to unread and back', () async {
    repo.emails = [buildEmail('1')];
    final toggle = ToggleEmailReadUseCase(repo);
    await toggle(repo.emails.single);
    expect(repo.emails.single.isRead, isTrue);
    await toggle(repo.emails.single);
    expect(repo.emails.single.isRead, isFalse);
  });

  test('DeleteEmailUseCase deletes by id and reports failures', () async {
    repo.emails = [buildEmail('1'), buildEmail('2')];
    final delete = DeleteEmailUseCase(repo);
    expect(await delete(repo.emails.first), isA<Success<void>>());
    expect(repo.emails.map((e) => e.id), ['2']);

    repo.failure = CommonErrors.server;
    expect(
      (await delete(repo.emails.single) as Failure).error,
      CommonErrors.server,
    );
  });
}
