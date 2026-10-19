import 'package:clean_architecture/config/env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AppConfig resolve({String env = '', String url = '', bool release = false}) =>
      AppConfig.resolve(env: env, apiBaseUrl: url, isRelease: release);

  test('debug builds fall back to dev and a local server', () {
    final config = resolve();
    expect(config.environment, AppEnvironment.dev);
    expect(config.apiBaseUrl.toString(), AppConfig.debugDefaultBaseUrl);
  });

  test('release builds fail fast without API_BASE_URL or ENV', () {
    expect(
      () => resolve(env: 'prod', release: true),
      throwsA(isA<ConfigurationError>()),
    );
    expect(
      () => resolve(url: 'https://x.example.com', release: true),
      throwsA(isA<ConfigurationError>()),
    );
    expect(
      resolve(
        env: 'prod',
        url: 'https://api.example.com',
        release: true,
      ).environment,
      AppEnvironment.prod,
    );
  });

  test('invalid values are rejected; prod requires https', () {
    expect(() => resolve(env: 'qa'), throwsA(isA<ConfigurationError>()));
    expect(() => resolve(url: '/emails'), throwsA(isA<ConfigurationError>()));
    expect(
      () => resolve(env: 'prod', url: 'http://api.example.com'),
      throwsA(isA<ConfigurationError>()),
    );
  });
}
