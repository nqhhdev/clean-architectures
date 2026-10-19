import 'package:clean_architecture/config/providers/core_providers.dart';
import 'package:clean_architecture/config/providers/email_providers.dart';
import 'package:clean_architecture/domain/models/email.dart';
import 'package:clean_architecture/utils/common_errors.dart';
import 'package:clean_architecture/utils/error.dart';
import 'package:clean_architecture/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Immutable UI state for the inbox.
@immutable
class EmailsState {
  const EmailsState({this.emails = const [], this.error});

  /// Newest first. Kept when an action fails so the list does not vanish.
  final List<Email> emails;

  /// Last non-urgent failure, cleared by the next successful action. Urgent
  /// failures (offline, session expired) go to the app status instead.
  final AppError? error;
}

final emailsViewModelProvider =
    AsyncNotifierProvider<EmailsViewModel, EmailsState>(EmailsViewModel.new);

class EmailsViewModel extends AsyncNotifier<EmailsState> {
  /// In-flight guard (ADR 0019): while one action runs, further actions are
  /// ignored rather than interleaved, so two taps cannot race on the cache.
  bool _busy = false;

  @override
  Future<EmailsState> build() {
    // watch (not read) in build: reload if the use case's repository changes.
    ref.watch(listEmailsUseCaseProvider);
    return _load();
  }

  Future<void> refresh() =>
      _exclusive(() => AsyncValue.guard(() => _load(force: true)));

  Future<void> toggleRead(Email email) {
    final toggle = ref.read(toggleEmailReadUseCaseProvider);
    return _afterWrite(() => toggle(email));
  }

  Future<void> delete(Email email) {
    final delete = ref.read(deleteEmailUseCaseProvider);
    return _afterWrite(() => delete(email));
  }

  Future<void> _afterWrite(Future<Result<void>> Function() write) => _exclusive(
    () => AsyncValue.guard(() async {
      final failure = (await write()).when(
        success: (_) => null,
        failure: (error) => error,
      );
      return failure == null ? _load() : _failed(failure);
    }),
  );

  /// Runs [action] unless another is in flight, then publishes its outcome.
  /// An unexpected exception is reported to the crash reporter and shown as
  /// `Common.Unknown` while the list stays visible, instead of escaping.
  Future<void> _exclusive(
    Future<AsyncValue<EmailsState>> Function() action,
  ) async {
    if (_busy) return;
    _busy = true;
    try {
      final reporter = ref.read(crashReporterProvider);
      final previous = state.value?.emails ?? const <Email>[];
      final outcome = await action();
      // The provider may have been disposed while awaiting (screen left).
      if (!ref.mounted) return;
      state = AsyncData(
        outcome.when(
          data: (data) => data,
          loading: () => EmailsState(emails: previous),
          error: (error, stack) {
            reporter.recordError(error, stack);
            return EmailsState(
              emails: previous,
              error: CommonErrors.unknown.withCause(error, stack),
            );
          },
        ),
      );
    } finally {
      _busy = false;
    }
  }

  Future<EmailsState> _load({bool force = false}) async {
    final list = ref.read(listEmailsUseCaseProvider);
    final previous = state.value?.emails ?? const <Email>[];
    final handler = ref.read(urgentFailureHandlerProvider);
    final result = await list(forceRefresh: force);
    return result.when(
      success: (emails) => EmailsState(emails: emails),
      failure: (error) => EmailsState(
        emails: previous,
        error: handler.handle(error) ? null : error,
      ),
    );
  }

  EmailsState _failed(AppError error) {
    final handled = ref.read(urgentFailureHandlerProvider).handle(error);
    return EmailsState(
      emails: state.value?.emails ?? const [],
      error: handled ? null : error,
    );
  }
}
