// Linux/CI goldens are canonical: skip locally with `--exclude-tags golden`.
@Tags(['golden'])
library;

import 'package:clean_architecture/ui/emails/email_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/builders.dart';
import '../../support/pump_app.dart';

/// Golden example. Images are rendered on Linux (the CI platform); regenerate
/// after an intentional visual change with `tool/update_goldens.sh`.
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
