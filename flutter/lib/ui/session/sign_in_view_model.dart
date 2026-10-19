import 'package:clean_architecture/config/providers/core_providers.dart';
import 'package:clean_architecture/utils/error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInViewModelProvider = NotifierProvider<SignInViewModel, void>(
  SignInViewModel.new,
);

/// Placeholder sign-in: it only clears the expired-session flag, which makes
/// the router leave the sign-in screen. Replace `signIn` with a real
/// authentication call and token storage ([ADR 0017]).
class SignInViewModel extends Notifier<void> {
  @override
  void build() {}

  void signIn() =>
      ref.read(urgentFailureHandlerProvider).clear(ErrorType.unauthorized);
}
