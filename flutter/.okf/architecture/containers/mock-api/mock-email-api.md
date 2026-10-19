---
type: Container
title: "Mock Email API"
description: "Development and e2e stand-in for the backend: a pure in-memory API with a tiny loopback HTTP server."
resource: tool
tags: [container, mock, testing]
status: stable
---
# Mock Email API

Not deployed. [`MockEmailApi`](../../../../tool/mock_email_api.dart) is pure logic (`handle(method, path, body)`);
[`mock_server.dart`](../../../../tool/mock_server.dart) wraps it in an HTTP server on loopback port 8080.
Tests use the same class in-process through [`mockClientFor`](../../../../test/support/mock_client.dart).

Control endpoints: `POST /__reset` restores seed data; `POST /__fail {"status": 401}` makes later requests fail.
Run it: `dart run tool/mock_server.dart`. iOS simulators share the host loopback; Android emulators use `10.0.2.2`.
