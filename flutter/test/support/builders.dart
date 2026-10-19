import 'package:clean_architecture/data/services/model/email_dto.dart';
import 'package:clean_architecture/domain/models/email.dart';

Email buildEmail(
  String id, {
  String subject = 'Subject',
  String sender = 'a@example.com',
  bool isRead = false,
  DateTime? receivedAt,
}) => Email.create(
  id: id,
  subject: subject,
  sender: sender,
  preview: 'preview',
  receivedAt: receivedAt ?? DateTime.utc(2026),
  isRead: isRead,
).when(success: (e) => e, failure: (e) => throw StateError('$e'));

EmailDto buildDto(
  String id, {
  String subject = 'Subject',
  String from = 'a@example.com',
  bool isRead = false,
  DateTime? receivedAt,
}) => EmailDto(
  id: id,
  subject: subject,
  from: from,
  preview: 'preview',
  receivedAt: receivedAt ?? DateTime.utc(2026),
  isRead: isRead,
);
