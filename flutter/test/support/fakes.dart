import 'dart:async';

import 'package:clean_architecture/data/repositories/emails/email_repository.dart';
import 'package:clean_architecture/data/services/api_exception.dart';
import 'package:clean_architecture/data/services/email_api_service.dart';
import 'package:clean_architecture/data/services/model/email_dto.dart';
import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/utils/error.dart';
import 'package:clean_architecture/utils/logger.dart';
import 'package:clean_architecture/utils/result.dart';
import 'package:clean_architecture/utils/urgent_failure_handler.dart';

/// Scriptable [EmailApiService]; counts calls so cache behaviour is observable.
class FakeEmailApiService implements EmailApiService {
  List<EmailDto> dtos = [];
  ApiException? failure;
  int getCalls = 0;
  int writeCalls = 0;

  @override
  Future<List<EmailDto>> getEmails() async {
    getCalls++;
    if (failure != null) throw failure!;
    return [...dtos];
  }

  @override
  Future<void> setRead(String id, {required bool isRead}) async {
    writeCalls++;
    if (failure != null) throw failure!;
  }

  @override
  Future<void> delete(String id) async {
    writeCalls++;
    if (failure != null) throw failure!;
    dtos = dtos.where((e) => e.id != id).toList();
  }
}

/// Scriptable [EmailRepository] for use case, ViewModel and screen tests.
class FakeEmailRepository implements EmailRepository {
  List<Email> emails = [];

  /// When set, every call fails with it.
  AppError? failure;

  /// When set, every call throws it (an unexpected bug, not a `Result`).
  Exception? crash;

  /// When set, calls wait for it before answering (to test in-flight guards).
  Completer<void>? gate;

  int getCalls = 0;
  int writeCalls = 0;
  bool? lastForceRefresh;

  Future<void> _enter() async {
    if (crash != null) throw crash!;
    await gate?.future;
  }

  @override
  Future<Result<List<Email>>> getAll({bool forceRefresh = false}) async {
    getCalls++;
    lastForceRefresh = forceRefresh;
    await _enter();
    return failure != null ? Failure(failure!) : Success([...emails]);
  }

  @override
  Future<Result<void>> setRead(String id, {required bool isRead}) async {
    writeCalls++;
    await _enter();
    if (failure != null) return Failure(failure!);
    emails = [
      for (final e in emails)
        if (e.id == id) e.copyWith(isRead: isRead) else e,
    ];
    return const Success(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    writeCalls++;
    await _enter();
    if (failure != null) return Failure(failure!);
    emails = emails.where((e) => e.id != id).toList();
    return const Success(null);
  }
}

/// Records what the code under test asks of the urgent failure handler.
class RecordingUrgentFailureHandler implements UrgentFailureHandler {
  final List<AppError> handled = [];
  final List<ErrorType> cleared = [];

  @override
  bool handle(AppError error) {
    final urgent =
        error.type == ErrorType.network || error.type == ErrorType.unauthorized;
    if (urgent) handled.add(error);
    return urgent;
  }

  @override
  void clear(ErrorType type) => cleared.add(type);
}

class RecordingLogger implements Logger {
  final List<(LogLevel, String)> entries = [];

  @override
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) => entries.add((level, message));

  String get text => entries.map((e) => e.$2).join('\n');
}

class RecordingCrashReporter implements CrashReporter {
  final List<(Object, bool)> errors = [];

  @override
  void recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) => errors.add((error, fatal));
}
