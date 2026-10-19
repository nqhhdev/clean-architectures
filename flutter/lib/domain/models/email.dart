import 'package:clean_architecture/domain/errors/email_errors.dart';
import 'package:clean_architecture/utils/result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'email.freezed.dart';

/// Example immutable model. Replace with your own domain; keep the shape:
/// a private constructor and a validated static [create] returning a [Result].
///
/// freezed gives `==`, `hashCode`, `toString` and `copyWith`. `copyWith` does
/// not re-run validation, so use it for state changes (for example `isRead`),
/// not to build a model from raw input.
@freezed
abstract class Email with _$Email {
  const factory Email._internal({
    required String id,
    required String subject,
    required String sender,
    required String preview,
    required DateTime receivedAt,
    required bool isRead,
  }) = _Email;

  static Result<Email> create({
    required String id,
    required String subject,
    required String sender,
    required String preview,
    required DateTime receivedAt,
    required bool isRead,
  }) {
    if (id.trim().isEmpty) return const Failure(EmailErrors.invalidId);
    return Success(
      Email._internal(
        id: id,
        subject: subject.trim(),
        sender: sender.trim(),
        preview: preview,
        receivedAt: receivedAt.toUtc(),
        isRead: isRead,
      ),
    );
  }
}
