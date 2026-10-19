import 'dart:convert';

/// In-memory stand-in for the emails REST API. Pure (no sockets), so the same
/// logic backs the local dev server (`mock_server.dart`) and in-process fakes
/// in tests.
///
/// Test-control endpoints: `POST /__reset` restores the seed data and
/// `POST /__fail` with `{"status": 401}` makes every later request fail with
/// that status (`{"status": null}` stops failing).
class MockEmailApi {
  MockEmailApi() {
    reset();
  }

  late List<Map<String, Object?>> _emails;

  /// When set, every request except the control endpoints answers with it.
  int? failStatus;

  List<Map<String, Object?>> get emails => _emails;

  void reset() {
    failStatus = null;
    _emails = [
      _email(
        'e1',
        'Welcome',
        'team@example.com',
        '2026-01-03T09:00:00Z',
        false,
      ),
      _email(
        'e2',
        'Invoice 42',
        'billing@example.com',
        '2026-01-02T09:00:00Z',
        false,
      ),
      _email('e3', 'Lunch?', 'sam@example.com', '2026-01-01T09:00:00Z', true),
    ];
  }

  static Map<String, Object?> _email(
    String id,
    String subject,
    String from,
    String receivedAt,
    bool isRead,
  ) => {
    'id': id,
    'subject': subject,
    'from': from,
    'preview': 'Preview of $subject',
    'receivedAt': receivedAt,
    'isRead': isRead,
  };

  ({int status, String body}) handle(
    String method,
    String path, [
    String? body,
  ]) {
    if (method == 'POST' && path == '/__reset') {
      reset();
      return (status: 204, body: '');
    }
    if (method == 'POST' && path == '/__fail') {
      final decoded = jsonDecode(body ?? '{}') as Map<String, Object?>;
      failStatus = decoded['status'] as int?;
      return (status: 204, body: '');
    }
    final fail = failStatus;
    if (fail != null) return (status: fail, body: '');

    if (method == 'GET' && path == '/emails') {
      return (status: 200, body: jsonEncode(_emails));
    }
    final match = RegExp(r'^/emails/([^/]+)$').firstMatch(path);
    if (match == null) return (status: 404, body: '');
    final id = Uri.decodeComponent(match.group(1)!);
    final index = _emails.indexWhere((e) => e['id'] == id);
    if (index < 0) return (status: 404, body: '');

    switch (method) {
      case 'PATCH':
        final decoded = jsonDecode(body ?? '{}') as Map<String, Object?>;
        _emails[index] = {
          ..._emails[index],
          'isRead': decoded['isRead']! as bool,
        };
        return (status: 200, body: jsonEncode(_emails[index]));
      case 'DELETE':
        _emails.removeAt(index);
        return (status: 204, body: '');
      default:
        return (status: 405, body: '');
    }
  }
}
