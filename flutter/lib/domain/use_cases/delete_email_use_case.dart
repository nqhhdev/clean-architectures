import 'package:clean_architecture/data/repositories/emails/email_repository.dart';
import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/utils/result.dart';

/// Deletes an email.
class DeleteEmailUseCase {
  const DeleteEmailUseCase(this._emails);

  final EmailRepository _emails;

  Future<Result<void>> call(Email email) => _emails.delete(email.id);
}
