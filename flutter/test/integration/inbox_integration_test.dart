// Integration: the real app (router, theme, l10n, screen, ViewModel, use
// cases, repository, ApiClient, service, JSON) against an in-process fake of
// the server. Runs headless with `flutter test`.
import 'package:clean_architecture/config/providers/core_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/mock_email_api.dart';
import '../support/mock_client.dart';
import '../support/pump_app.dart';

void main() {
  late MockEmailApi server;
  late MockServerClient client;

  setUp(() {
    server = MockEmailApi();
    client = MockServerClient(server);
  });

  Future<void> launch(WidgetTester tester) async {
    await tester.pumpWidget(
      testApp(overrides: [httpClientProvider.overrideWithValue(client)]),
    );
    await tester.pumpAndSettle();
  }

  Finder retryInBanner() => find.descendant(
    of: find.byKey(const Key('app-status-banner')),
    matching: find.text('Retry'),
  );

  testWidgets('shows the server inbox, newest first', (tester) async {
    await launch(tester);
    double top(String id) => tester.getTopLeft(find.byKey(Key('email-$id'))).dy;
    expect(find.text('Welcome'), findsOneWidget);
    expect(top('e1'), lessThan(top('e2')));
    expect(top('e2'), lessThan(top('e3')));
  });

  testWidgets('marking read and deleting are stored on the server', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(find.byKey(const Key('email-e1')));
    await tester.pumpAndSettle();
    expect(server.emails.firstWhere((e) => e['id'] == 'e1')['isRead'], isTrue);

    await tester.tap(find.byKey(const Key('delete-e2')));
    await tester.pumpAndSettle();
    expect(server.emails.map((e) => e['id']), ['e1', 'e3']);
    expect(find.text('Invoice 42'), findsNothing);
  });

  testWidgets('a malformed payload is a server error with a retry row', (
    tester,
  ) async {
    server.emails.add({
      'id': 'x',
      'subject': 123,
      'receivedAt': '2026-01-04T09:00:00Z',
    });
    await launch(tester);
    expect(find.byKey(const Key('emails-error')), findsOneWidget);
    expect(
      find.text('The server could not process the request.'),
      findsOneWidget,
    );
  });

  testWidgets('an expired session goes to sign-in; signing in returns', (
    tester,
  ) async {
    await launch(tester);
    server.failStatus = 401;
    await tester.tap(find.byKey(const Key('email-e1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('sign-in-screen')), findsOneWidget);

    server.failStatus = null;
    await tester.tap(find.byKey(const Key('sign-in-button')));
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
  });

  testWidgets(
    'offline shows a banner; only a real response clears it (ADR 0019)',
    (tester) async {
      await launch(tester);
      client.offline = true;
      await tester.tap(find.byKey(const Key('email-e1')));
      await tester.pumpAndSettle();
      expect(find.text('You are offline.'), findsOneWidget);

      await tester.tap(retryInBanner()); // still offline: the banner stays
      await tester.pumpAndSettle();
      expect(find.text('You are offline.'), findsOneWidget);

      client.offline = false;
      await tester.tap(retryInBanner());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('app-status-banner')), findsNothing);
    },
  );
}
