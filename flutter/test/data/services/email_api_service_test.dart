import 'dart:convert';

import 'package:clean_architecture/data/services/api_client.dart';
import 'package:clean_architecture/data/services/api_exception.dart';
import 'package:clean_architecture/data/services/email_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

EmailApiService serviceReturning(Object? json) => EmailApiService(
  ApiClient(
    client: MockClient((_) async => http.Response(jsonEncode(json), 200)),
    baseUrl: Uri.parse('http://host'),
  ),
);

const goodEmail = {
  'id': 'e1',
  'subject': 'Hi',
  'from': 'a@example.com',
  'receivedAt': '2026-01-01T00:00:00Z',
};

Matcher malformed() => throwsA(
  isA<ApiException>()
      .having((e) => e.failure, 'failure', ApiFailure.malformed)
      .having((e) => e.stackTrace, 'stackTrace', isNotNull),
);

void main() {
  test('parses a list into DTOs, defaulting missing fields', () async {
    final dtos = await serviceReturning([goodEmail]).getEmails();
    expect(dtos.single.id, 'e1');
    expect(dtos.single.from, 'a@example.com');
    expect(dtos.single.isRead, isFalse);
  });

  test('a wrong-typed field becomes ApiFailure.malformed', () async {
    await expectLater(
      serviceReturning([
        {...goodEmail, 'subject': 123},
      ]).getEmails(),
      malformed(),
    );
  });

  test('other malformed payloads never escape as raw exceptions', () async {
    for (final json in <Object?>[
      {'not': 'a list'},
      [null],
      [
        {'subject': 'no id or date'},
      ],
      [
        {...goodEmail, 'receivedAt': 'yesterday'},
      ],
    ]) {
      await expectLater(
        serviceReturning(json).getEmails(),
        malformed(),
        reason: '$json',
      );
    }
  });
}
