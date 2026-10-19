import 'dart:convert';
import 'dart:io';

import 'mock_email_api.dart';

/// Local dev/e2e backend: `dart run tool/mock_server.dart [port]` (default 8080).
/// Listens on loopback only. iOS simulators share the host's loopback; Android
/// emulators reach it at http://10.0.2.2:PORT.
Future<void> main(List<String> args) async {
  final port = args.isNotEmpty ? int.parse(args.first) : 8080;
  final api = MockEmailApi();
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout.writeln('mock email API on http://127.0.0.1:${server.port}');
  await for (final request in server) {
    final body = await utf8.decoder.bind(request).join();
    final reply = api.handle(request.method, request.uri.path, body);
    request.response
      ..statusCode = reply.status
      ..headers.contentType = ContentType.json
      ..write(reply.body);
    await request.response.close();
  }
}
