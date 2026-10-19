import 'package:clean_architecture/config/providers/email_providers.dart';
import 'package:clean_architecture/ui/core/routing/app_router.dart';
import 'package:clean_architecture/utils/common_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders.dart';
import '../../support/fakes.dart';
import '../../support/pump_app.dart';

void main() {
  test('sessionRedirect sends an expired session to sign-in and back', () {
    String? go({required bool expired, required String at}) =>
        sessionRedirect(sessionExpired: expired, location: at);
    expect(go(expired: true, at: AppRoutes.inbox), AppRoutes.signIn);
    expect(go(expired: true, at: AppRoutes.signIn), isNull);
    expect(go(expired: false, at: AppRoutes.signIn), AppRoutes.inbox);
    expect(go(expired: false, at: AppRoutes.inbox), isNull);
  });

  testWidgets(
    'a 401 redirects to sign-in, and signing in returns to the inbox',
    (tester) async {
      final repo = FakeEmailRepository()
        ..emails = [buildEmail('1', subject: 'Hello')];
      await tester.pumpWidget(
        testApp(overrides: [emailRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();
      expect(find.text('Hello'), findsOneWidget);

      repo.failure = CommonErrors.unauthorized;
      await tester.tap(find.byKey(const Key('email-1')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('sign-in-screen')), findsOneWidget);

      repo.failure = null;
      await tester.tap(find.byKey(const Key('sign-in-button')));
      await tester.pumpAndSettle();
      expect(find.text('Hello'), findsOneWidget);
    },
  );
}
