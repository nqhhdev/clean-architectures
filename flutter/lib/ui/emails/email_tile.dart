import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/ui/core/l10n/generated/app_localizations.dart';
import 'package:clean_architecture/ui/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// One row of the inbox. Stateless: everything comes in as parameters, which
/// makes it easy to test and to golden-test.
class EmailTile extends StatelessWidget {
  const EmailTile({
    required this.email,
    required this.onToggleRead,
    required this.onDelete,
    super.key,
  });

  final Email email;
  final VoidCallback onToggleRead;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: Icon(
        email.isRead ? Icons.drafts_outlined : Icons.mark_email_unread,
        color: email.isRead ? null : context.appColors.unreadAccent,
      ),
      title: Text(
        email.subject.isEmpty ? l10n.noSubject : email.subject,
        style: email.isRead
            ? context.appText.readTitle
            : context.appText.unreadTitle,
      ),
      subtitle: Text(
        '${email.sender} - ${email.preview}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onToggleRead,
      trailing: IconButton(
        key: Key('delete-${email.id}'),
        tooltip: l10n.delete,
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}
