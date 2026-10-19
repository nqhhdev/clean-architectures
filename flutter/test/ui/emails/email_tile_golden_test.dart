import 'package:clean_architecture/ui/emails/email_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders.dart';
import '../../support/pump_app.dart';

/// Golden example. Regenerate after an intentional visual change:
///   flutter test --update-goldens test/ui/emails/email_tile_golden_test.dart
/// Text renders with the test font (Ahem), so the images do not depend on the
/// platform's fonts.
void main() {
  Widget tile({required bool isRead, required Brightness brightness}) {
    return testScreen(
      Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('golden'),
            child: SizedBox(
              width: 360,
              child: EmailTile(
                email: buildEmail('1', subject: 'Welcome', isRead: isRead),
                onToggleRead: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      ),
      brightness: brightness,
    );
  }

  testWidgets('EmailTile unread', (tester) async {
    await tester.pumpWidget(tile(isRead: false, brightness: Brightness.light));
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('golden')),
      matchesGoldenFile('goldens/email_tile_unread.png'),
    );
  });
}
