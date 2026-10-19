import 'package:clean_architecture/config/app_status.dart';
import 'package:clean_architecture/config/providers/core_providers.dart';
import 'package:clean_architecture/utils/common_errors.dart';
import 'package:clean_architecture/utils/error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  AppStatus status() => container.read(appStatusProvider);

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('network and unauthorized failures are urgent and recorded', () {
    final handler = container.read(urgentFailureHandlerProvider);
    expect(handler.handle(CommonErrors.network), isTrue);
    expect(status(), const AppStatus(offline: true));
    expect(handler.handle(CommonErrors.unauthorized), isTrue);
    expect(status(), const AppStatus(offline: true, sessionExpired: true));
  });

  test('other failures are not urgent and change nothing', () {
    final handler = container.read(urgentFailureHandlerProvider);
    for (final error in [
      CommonErrors.server,
      CommonErrors.conflict,
      CommonErrors.validation,
      CommonErrors.unknown,
    ]) {
      expect(handler.handle(error), isFalse, reason: error.code);
    }
    expect(status(), const AppStatus());
  });

  test('clear is scoped to one failure type (ADR 0019)', () {
    final handler = container.read(urgentFailureHandlerProvider)
      ..handle(CommonErrors.network)
      ..handle(CommonErrors.unauthorized);

    handler.clear(ErrorType.network);
    expect(status(), const AppStatus(sessionExpired: true));

    handler.clear(ErrorType.validation);
    expect(status(), const AppStatus(sessionExpired: true));

    handler.clear(ErrorType.unauthorized);
    expect(status(), const AppStatus());
  });
}
