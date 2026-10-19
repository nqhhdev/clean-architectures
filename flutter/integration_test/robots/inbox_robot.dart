import 'package:clean_architecture/app.dart';
import 'package:clean_architecture/config/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

/// Robot for the inbox screen: tests read as user actions, and screen details
/// (keys, icons) live here only.
class InboxRobot {
  InboxRobot(this.tester);

  final WidgetTester tester;

  static final Uri _server = AppConfig.fromEnvironment().apiBaseUrl;

  static Uri _control(String path) => _server.replace(path: path);

  /// Restore the server's seed data (and stop failing) before a scenario.
  static Future<void> resetServer() async {
    final response = await http.post(_control('/__reset'));
    if (response.statusCode != 204) {
      throw StateError(
        'Mock server not reachable at $_server (${response.statusCode})',
      );
    }
  }

  static Future<void> serverFailsWith(int? status) => http.post(
    _control('/__fail'),
    headers: {'content-type': 'application/json'},
    body: '{"status": ${status ?? 'null'}}',
  );

  Future<void> launch() async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();
  }

  Finder _row(String id) => find.byKey(Key('email-$id'));

  void seeEmail(String subject) => expect(find.text(subject), findsOneWidget);

  void doNotSeeEmail(String subject) =>
      expect(find.text(subject), findsNothing);

  void seeNewestFirst(List<String> ids) {
    final tops = [for (final id in ids) tester.getTopLeft(_row(id)).dy];
    expect(tops, orderedEquals([...tops]..sort()));
  }

  void seeUnread(String id) => expect(
    find.descendant(
      of: _row(id),
      matching: find.byIcon(Icons.mark_email_unread),
    ),
    findsOneWidget,
  );

  void seeRead(String id) => expect(
    find.descendant(of: _row(id), matching: find.byIcon(Icons.drafts_outlined)),
    findsOneWidget,
  );

  Future<void> tapEmail(String id) async {
    await tester.tap(_row(id));
    await tester.pumpAndSettle();
  }

  Future<void> deleteEmail(String id) async {
    await tester.tap(find.byKey(Key('delete-$id')));
    await tester.pumpAndSettle();
  }

  void seeSignInScreen() =>
      expect(find.byKey(const Key('sign-in-screen')), findsOneWidget);

  void doNotSeeSignInScreen() =>
      expect(find.byKey(const Key('sign-in-screen')), findsNothing);

  Future<void> signIn() async {
    await tester.tap(find.byKey(const Key('sign-in-button')));
    await tester.pumpAndSettle();
  }
}
