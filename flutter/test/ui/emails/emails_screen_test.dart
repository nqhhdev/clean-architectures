import 'package:clean_architecture/config/providers/email_providers.dart';
import 'package:clean_architecture/ui/emails/emails_screen.dart';
import 'package:clean_architecture/utils/common_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders.dart';
import '../../support/fakes.dart';
import '../../support/pump_app.dart';

void main() {
  late FakeEmailRepository repo;

  setUp(() {
    repo = FakeEmailRepository()
      ..emails = [
        buildEmail('1', subject: 'First', receivedAt: DateTime.utc(2026, 1, 2)),
        buildEmail(
          '2',
          subject: 'Second',
          receivedAt: DateTime.utc(2026),
          isRead: true,
        ),
      ];
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      testScreen(
        const EmailsScreen(),
        overrides: [emailRepositoryProvider.overrideWithValue(repo)],
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder inRow(String id, IconData icon) => find.descendant(
    of: find.byKey(Key('email-$id')),
    matching: find.byIcon(icon),
  );

  testWidgets('lists emails, unread ones with the unread icon', (tester) async {
    await pumpScreen(tester);
    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    expect(inRow('1', Icons.mark_email_unread), findsOneWidget);
    expect(inRow('2', Icons.drafts_outlined), findsOneWidget);
  });

  testWidgets('tapping an email toggles read', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.byKey(const Key('email-1')));
    await tester.pumpAndSettle();
    expect(inRow('1', Icons.drafts_outlined), findsOneWidget);
  });

  testWidgets('delete removes the row', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.byKey(const Key('delete-1')));
    await tester.pumpAndSettle();
    expect(find.text('First'), findsNothing);
    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets(
    'a non-urgent failure shows a localized error row; Retry recovers',
    (tester) async {
      await pumpScreen(tester);
      repo.failure = CommonErrors.server;
      await tester.tap(find.byKey(const Key('email-1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('emails-error')), findsOneWidget);
      expect(
        find.text('The server could not process the request.'),
        findsOneWidget,
      );
      expect(find.text('First'), findsOneWidget, reason: 'list is kept');

      repo.failure = null;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('emails-error')), findsNothing);
    },
  );

  testWidgets(
    'an urgent network failure shows the banner with a working Retry',
    (tester) async {
      await pumpScreen(tester);
      repo.failure = CommonErrors.network;
      await tester.tap(find.byKey(const Key('email-1')));
      await tester.pumpAndSettle();
      expect(find.text('You are offline.'), findsOneWidget);
      expect(find.byKey(const Key('emails-error')), findsNothing);

      final before = repo.getCalls;
      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('app-status-banner')),
          matching: find.text('Retry'),
        ),
      );
      await tester.pumpAndSettle();
      expect(repo.getCalls, greaterThan(before), reason: 'Retry refreshes');
    },
  );
}
