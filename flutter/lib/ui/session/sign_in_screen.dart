import 'package:clean_architecture/ui/core/l10n/generated/app_localizations.dart';
import 'package:clean_architecture/ui/session/sign_in_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the router sends the user when the session has expired.
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.signInTitle)),
      body: Center(
        child: Column(
          key: const Key('sign-in-screen'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.sessionExpiredMessage),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('sign-in-button'),
              onPressed: ref.read(signInViewModelProvider.notifier).signIn,
              child: Text(l10n.signIn),
            ),
          ],
        ),
      ),
    );
  }
}
