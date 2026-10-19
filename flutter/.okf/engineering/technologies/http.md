---
type: Technology
title: "http package"
description: "package:http is the HTTP client, used only inside ApiClient."
resource: pubspec.yaml
tags: [technology, http]
status: stable
---
# http

`http ^1.6.0`. Only [`ApiClient`](../../../lib/data/services/api_client.dart) uses it; the `http.Client` comes from `httpClientProvider`
in `config/providers/core_providers.dart`. Tests use `package:http/testing.dart` (`MockClient`, [`mock_client.dart`](../../../test/support/mock_client.dart)).
Decision: [ADR 0018](../../adr/0018-data-layer-api-client-dtos-errors.md).
