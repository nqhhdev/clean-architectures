import 'package:clean_architecture/utils/error.dart';
import 'package:clean_architecture/utils/urgent_failure_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_status.freezed.dart';

/// App-wide urgent problems, tracked per failure type so clearing one never
/// hides the other (ADR 0019).
@freezed
abstract class AppStatus with _$AppStatus {
  const factory AppStatus({
    @Default(false) bool offline,
    @Default(false) bool sessionExpired,
  }) = _AppStatus;
}

/// The one owner of [AppStatus] (ADR 0005).
class AppStatusNotifier extends Notifier<AppStatus> {
  @override
  AppStatus build() => const AppStatus();

  void update(AppStatus Function(AppStatus current) change) =>
      state = change(state);
}

final appStatusProvider = NotifierProvider<AppStatusNotifier, AppStatus>(
  AppStatusNotifier.new,
);

/// Default [UrgentFailureHandler]: records the problem in [appStatusProvider].
/// The router turns `sessionExpired` into a redirect to the sign-in screen.
class AppStatusFailureHandler implements UrgentFailureHandler {
  AppStatusFailureHandler(this._status);

  final AppStatusNotifier _status;

  @override
  bool handle(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        _status.update((s) => s.copyWith(offline: true));
        return true;
      case ErrorType.unauthorized:
        _status.update((s) => s.copyWith(sessionExpired: true));
        return true;
      case ErrorType.validation ||
          ErrorType.notFound ||
          ErrorType.conflict ||
          ErrorType.failure:
        return false;
    }
  }

  @override
  void clear(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        _status.update((s) => s.copyWith(offline: false));
      case ErrorType.unauthorized:
        _status.update((s) => s.copyWith(sessionExpired: false));
      case ErrorType.validation ||
          ErrorType.notFound ||
          ErrorType.conflict ||
          ErrorType.failure:
        break;
    }
  }
}
