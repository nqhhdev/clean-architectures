import 'package:clean_architecture/config/app_status.dart';
import 'package:clean_architecture/ui/emails/emails_screen.dart';
import 'package:clean_architecture/ui/session/sign_in_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const inbox = '/';
  static const signIn = '/sign-in';
}

/// Where to send the user given the session state, or null to stay put.
/// Pure so it can be tested without a router.
String? sessionRedirect({
  required bool sessionExpired,
  required String location,
}) {
  final atSignIn = location == AppRoutes.signIn;
  if (sessionExpired && !atSignIn) return AppRoutes.signIn;
  if (!sessionExpired && atSignIn) return AppRoutes.inbox;
  return null;
}

/// The router. It re-evaluates its redirect whenever the session-expired flag
/// changes, so a 401 anywhere in the app lands the user on the sign-in screen.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref
    ..onDispose(refresh.dispose)
    ..listen(
      appStatusProvider.select((status) => status.sessionExpired),
      (_, _) => refresh.value++,
    );

  final router = GoRouter(
    refreshListenable: refresh,
    redirect: (context, state) => sessionRedirect(
      sessionExpired: ref.read(appStatusProvider).sessionExpired,
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.inbox,
        builder: (context, state) => const EmailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
