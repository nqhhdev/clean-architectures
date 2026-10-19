// End-to-end: the real app on a simulator/device talking over real HTTP to the
// mock server. Start the server first:
//
//   dart run tool/mock_server.dart
//   flutter test integration_test/inbox_e2e_test.dart -d <device id>
//
// Android emulators reach the host at 10.0.2.2:
//   --dart-define=API_BASE_URL=http://10.0.2.2:8080
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'robots/inbox_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(InboxRobot.resetServer);

  testWidgets('inbox lists the server emails, newest first', (tester) async {
    final inbox = InboxRobot(tester);
    await inbox.launch();

    inbox.seeEmail('Welcome');
    inbox.seeEmail('Invoice 42');
    inbox.seeEmail('Lunch?');
    inbox.seeNewestFirst(['e1', 'e2', 'e3']);
    inbox.seeUnread('e1');
    inbox.seeRead('e3');
  });

  testWidgets('a user reads an email, then deletes another', (tester) async {
    final inbox = InboxRobot(tester);
    await inbox.launch();

    await inbox.tapEmail('e1');
    inbox.seeRead('e1');

    await inbox.deleteEmail('e2');
    inbox.doNotSeeEmail('Invoice 42');
    inbox.seeEmail('Welcome');
  });

  testWidgets('an expired session sends the user to sign-in and back', (
    tester,
  ) async {
    final inbox = InboxRobot(tester);
    await inbox.launch();

    await InboxRobot.serverFailsWith(401);
    await inbox.tapEmail('e1');
    inbox.seeSignInScreen();

    await InboxRobot.serverFailsWith(null);
    await inbox.signIn();
    inbox.doNotSeeSignInScreen();
    inbox.seeEmail('Welcome');
  });
}
