import 'package:clean_architecture/data/repositories/emails/email_repository.dart';
import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/utils/result.dart';

/// The inbox as the user wants to read it: newest first.
class ListEmailsUseCase {
  const ListEmailsUseCase(this._emails);

  final EmailRepository _emails;

  Future<Result<List<Email>>> call({bool forceRefresh = false}) async {
    final result = await _emails.getAll(forceRefresh: forceRefresh);
    return result.when(
      success: (emails) => Success(
        [...emails]..sort((a, b) => b.receivedAt.compareTo(a.receivedAt)),
      ),
      failure: Failure.new,
    );
  }
}
