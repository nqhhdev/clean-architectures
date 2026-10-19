import 'package:clean_architecture/data/services/model/email_dto.dart';
import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/utils/result.dart';

/// Wire model to domain model. Validation lives in `Email.create`.
Result<Email> emailFromDto(EmailDto dto) => Email.create(
  id: dto.id,
  subject: dto.subject,
  sender: dto.from,
  preview: dto.preview,
  receivedAt: dto.receivedAt,
  isRead: dto.isRead,
);
