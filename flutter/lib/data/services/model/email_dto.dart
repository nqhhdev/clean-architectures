import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_dto.freezed.dart';
part 'email_dto.g.dart';

/// Wire format of an email. Kept apart from the domain model so API changes
/// stay inside `data/`. Parsing is strict about types (see `build.yaml`):
/// a wrong-typed field throws, and the service turns that into
/// `ApiFailure.malformed`.
@freezed
abstract class EmailDto with _$EmailDto {
  const factory EmailDto({
    required String id,
    required DateTime receivedAt,
    @Default('') String subject,
    @Default('') String from,
    @Default('') String preview,
    @Default(false) bool isRead,
  }) = _EmailDto;

  factory EmailDto.fromJson(Map<String, dynamic> json) =>
      _$EmailDtoFromJson(json);
}
