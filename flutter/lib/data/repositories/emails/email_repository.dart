import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/utils/result.dart';

/// Source of truth for emails. Abstract so each environment can supply its own
/// implementation (`*_remote.dart` over the API; a fake in tests).
abstract interface class EmailRepository {
  /// Cached list unless [forceRefresh] is set or nothing is cached yet.
  Future<Result<List<Email>>> getAll({bool forceRefresh = false});

  Future<Result<void>> setRead(String id, {required bool isRead});

  Future<Result<void>> delete(String id);
}
