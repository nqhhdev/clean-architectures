import 'package:clean_architecture/data/repositories/emails/email_repository.dart';
import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/utils/result.dart';

/// Flips an email between read and unread.
class ToggleEmailReadUseCase {
  const ToggleEmailReadUseCase(this._emails);

  final EmailRepository _emails;

  Future<Result<void>> call(Email email) =>
      _emails.setRead(email.id, isRead: !email.isRead);
}
