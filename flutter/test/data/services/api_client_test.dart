import 'package:clean_architecture/data/services/api_client.dart';
import 'package:clean_architecture/data/services/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../support/fakes.dart';

void main() {
  final requests = <http.Request>[];
  final statuses = <int>[];
  final logger = RecordingLogger();

  ApiClient clientFor(
    Future<http.Response> Function(http.Request) handler, {
    AuthTokenProvider? token,
  }) {
    requests.clear();
    statuses.clear();
    return ApiClient(
      client: MockClient((r) {
        requests.add(r);
        return handler(r);
      }),
      baseUrl: Uri.parse('http://host/api/'),
      tokenProvider: token,
      logger: logger,
      onResponse: statuses.add,
      sleep: (_) async {},
    );
  }

  Matcher failsWith(ApiFailure f) =>
      throwsA(isA<ApiException>().having((e) => e.failure, 'failure', f));

  test('builds the url, sets headers and the bearer token', () async {
    final client = clientFor(
      (_) async => http.Response('[]', 200),
      token: () async => 'secret-token',
    );
    await client.getJson('/emails');
    expect(requests.single.url.toString(), 'http://host/api/emails');
    expect(requests.single.headers['accept'], 'application/json');
    expect(requests.single.headers['authorization'], 'Bearer secret-token');
    expect(logger.text, contains('GET /emails -> 200'));
    expect(logger.text, isNot(contains('secret-token')));
  });

  test('maps HTTP statuses to failures and reports every response', () async {
    for (final (status, failure) in [
      (400, ApiFailure.validation),
      (401, ApiFailure.unauthorized),
      (404, ApiFailure.notFound),
      (409, ApiFailure.conflict),
      (500, ApiFailure.server),
    ]) {
      final client = clientFor((_) async => http.Response('', status));
      await expectLater(client.patchJson('/x', {}), failsWith(failure));
      expect(statuses, [status]);
    }
  });

  test('a transport error is a network failure that keeps its cause', () async {
    final client = clientFor((_) async => throw http.ClientException('down'));
    await expectLater(
      client.patchJson('/x', {}),
      throwsA(
        isA<ApiException>()
            .having((e) => e.failure, 'failure', ApiFailure.network)
            .having((e) => e.cause, 'cause', isA<http.ClientException>())
            .having((e) => e.stackTrace, 'stackTrace', isNotNull),
      ),
    );
  });

  test('GET retries a transient failure; PATCH does not', () async {
    var calls = 0;
    final flaky = clientFor((_) async {
      calls++;
      if (calls < 3) throw http.ClientException('flaky');
      return http.Response('[]', 200);
    });
    await flaky.getJson('/emails');
    expect(calls, 3);

    final down = clientFor((_) async => throw http.ClientException('down'));
    await expectLater(down.patchJson('/x', {}), failsWith(ApiFailure.network));
    expect(requests, hasLength(1), reason: 'PATCH is not retried');
  });
}
