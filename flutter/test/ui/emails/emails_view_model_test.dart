import 'dart:async';

import 'package:clean_architecture/config/providers/core_providers.dart';
import 'package:clean_architecture/config/providers/email_providers.dart';
import 'package:clean_architecture/ui/emails/emails_view_model.dart';
import 'package:clean_architecture/utils/common_errors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders.dart';
import '../../support/fakes.dart';

void main() {
  late FakeEmailRepository repo;
  late RecordingUrgentFailureHandler handler;
  late RecordingCrashReporter reporter;
  late ProviderContainer container;

  EmailsState current() => container.read(emailsViewModelProvider).requireValue;
  EmailsViewModel viewModel() =>
      container.read(emailsViewModelProvider.notifier);

  setUp(() {
    repo = FakeEmailRepository()
      ..emails = [
        buildEmail('old', receivedAt: DateTime.utc(2026)),
        buildEmail('new', receivedAt: DateTime.utc(2026, 1, 2)),
      ];
    handler = RecordingUrgentFailureHandler();
    reporter = RecordingCrashReporter();
    container = ProviderContainer(
      overrides: [
        emailRepositoryProvider.overrideWithValue(repo),
        urgentFailureHandlerProvider.overrideWithValue(handler),
        crashReporterProvider.overrideWithValue(reporter),
      ],
    );
    addTearDown(container.dispose);
  });

  test('loads newest first (the use case sorts)', () async {
    await container.read(emailsViewModelProvider.future);
    expect(current().emails.map((e) => e.id), ['new', 'old']);
    expect(current().error, isNull);
  });

  test('toggleRead flips the flag', () async {
    await container.read(emailsViewModelProvider.future);
    await viewModel().toggleRead(current().emails.first);
    expect(current().emails.firstWhere((e) => e.id == 'new').isRead, isTrue);
  });

  test('delete removes the email', () async {
    await container.read(emailsViewModelProvider.future);
    await viewModel().delete(current().emails.first);
    expect(current().emails.map((e) => e.id), ['old']);
  });

  group('failures', () {
    test('a non-urgent failure is kept in the state, with the list', () async {
      await container.read(emailsViewModelProvider.future);
      repo.failure = CommonErrors.server;
      await viewModel().refresh();
      expect(current().error, CommonErrors.server);
      expect(current().emails, hasLength(2));
      expect(handler.handled, isEmpty);
    });

    test('an urgent failure goes to the handler, not into the state', () async {
      await container.read(emailsViewModelProvider.future);
      repo.failure = CommonErrors.unauthorized;
      await viewModel().toggleRead(current().emails.first);
      expect(handler.handled, [CommonErrors.unauthorized]);
      expect(current().error, isNull);
      expect(current().emails, hasLength(2));
    });

    test('an unexpected exception is reported and the list stays', () async {
      await container.read(emailsViewModelProvider.future);
      repo.crash = Exception('bug');
      await viewModel().refresh();

      expect(current().error?.code, CommonErrors.unknown.code);
      expect(current().error?.cause, isA<Exception>());
      expect(current().emails, hasLength(2));
      expect(reporter.errors.single.$1, isA<Exception>());
    });
  });

  group('async rules (ADR 0019)', () {
    test('while one action is in flight, another is ignored', () async {
      await container.read(emailsViewModelProvider.future);
      repo.gate = Completer<void>();
      final first = viewModel().delete(current().emails.first);
      await Future<void>.delayed(Duration.zero);
      final second = viewModel().delete(current().emails.last);
      await second; // returns immediately: it was dropped

      expect(repo.writeCalls, 1, reason: 'only the first delete started');
      repo.gate!.complete();
      await first;
      expect(current().emails.map((e) => e.id), ['old']);

      await viewModel().delete(current().emails.single);
      expect(
        current().emails,
        isEmpty,
        reason: 'the guard released afterwards',
      );
    });

    test('disposing while awaiting does not touch the dead provider', () async {
      await container.read(emailsViewModelProvider.future);
      repo.gate = Completer<void>();
      final subscription = container.listen(emailsViewModelProvider, (_, _) {});
      final pending = viewModel().refresh();
      await Future<void>.delayed(Duration.zero);

      subscription.close();
      container.invalidate(emailsViewModelProvider);
      repo.gate!.complete();
      await expectLater(pending, completes);
    });
  });
}
