import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../tool/mock_email_api.dart';

/// An `http.Client` that answers from `api` in-process (no sockets). While
/// `offline` is true every request fails like an unreachable server.
class MockServerClient extends MockClient {
  MockServerClient(MockEmailApi api)
    : super((request) async {
        if (_offlineFlags[api] ?? false) {
          throw http.ClientException('server unreachable');
        }
        final reply = api.handle(
          request.method,
          request.url.path,
          request.body,
        );
        return http.Response(reply.body, reply.status);
      }) {
    _api = api;
  }

  late final MockEmailApi _api;

  static final _offlineFlags = Expando<bool>('offline');

  bool get offline => _offlineFlags[_api] ?? false;
  set offline(bool value) => _offlineFlags[_api] = value;
}

/// Kept for tests that do not need the offline switch.
MockClient mockClientFor(MockEmailApi api) => MockServerClient(api);
