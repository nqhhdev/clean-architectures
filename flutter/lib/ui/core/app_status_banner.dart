import 'package:clean_architecture/config/app_status.dart';
import 'package:clean_architecture/ui/core/l10n/generated/app_localizations.dart';
import 'package:clean_architecture/ui/core/routing/app_router.dart';
import 'package:clean_architecture/ui/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shows urgent, app-wide problems recorded by the urgent failure handler,
/// each with the action that resolves it: Retry when offline, Sign in when the
/// session expired. [onRetry] belongs to the screen showing the banner.
class AppStatusBanner extends ConsumerWidget {
  const AppStatusBanner({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(appStatusProvider);
    final l10n = AppLocalizations.of(context);
    final (message, actionLabel, action) = status.sessionExpired
        ? (
            l10n.sessionExpiredMessage,
            l10n.signIn,
            () => context.go(AppRoutes.signIn),
          )
        : status.offline
        ? (l10n.offlineMessage, l10n.retry, onRetry)
        : (null, null, null);
    if (message == null) return const SizedBox.shrink();
    return MaterialBanner(
      key: const Key('app-status-banner'),
      backgroundColor: context.appColors.statusBanner,
      content: Text(message),
      actions: [TextButton(onPressed: action, child: Text(actionLabel!))],
    );
  }
}
