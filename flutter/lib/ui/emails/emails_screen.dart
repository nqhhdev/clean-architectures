import 'package:clean_architecture/ui/core/app_status_banner.dart';
import 'package:clean_architecture/ui/core/l10n/error_localizations.dart';
import 'package:clean_architecture/ui/core/l10n/generated/app_localizations.dart';
import 'package:clean_architecture/ui/emails/email_tile.dart';
import 'package:clean_architecture/ui/emails/emails_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailsScreen extends ConsumerWidget {
  const EmailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(emailsViewModelProvider);
    final viewModel = ref.read(emailsViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inboxTitle)),
      body: Column(
        children: [
          AppStatusBanner(onRetry: viewModel.refresh),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                key: const Key('emails-unexpected-error'),
                child: TextButton(
                  onPressed: viewModel.refresh,
                  child: Text('${l10n.unexpectedError} ${l10n.retry}'),
                ),
              ),
              data: (data) => Column(
                children: [
                  if (data.error != null)
                    ListTile(
                      key: const Key('emails-error'),
                      title: Text(l10n.errorMessage(data.error!)),
                      trailing: TextButton(
                        onPressed: viewModel.refresh,
                        child: Text(l10n.retry),
                      ),
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: viewModel.refresh,
                      child: data.emails.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 120),
                                Center(child: Text(l10n.emptyInbox)),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: data.emails.length,
                              itemBuilder: (context, index) {
                                final email = data.emails[index];
                                return EmailTile(
                                  key: Key('email-${email.id}'),
                                  email: email,
                                  onToggleRead: () =>
                                      viewModel.toggleRead(email),
                                  onDelete: () => viewModel.delete(email),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
