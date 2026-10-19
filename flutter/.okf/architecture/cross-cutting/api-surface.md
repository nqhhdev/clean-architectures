---
type: Mechanism
title: "API Surface"
description: "The REST contract the app consumes: three endpoints on /emails."
tags: [api, rest, contract]
status: stable
---
# API Surface

Base URL from `API_BASE_URL` ([Configuration and Environments](configuration.md)). JSON. Status mapping: [Error Handling](error-handling.md).

| Method | Path | Body | Success |
|---|---|---|---|
| GET | `/emails` | - | `200` array of `{id, receivedAt (ISO 8601), subject?, from?, preview?, isRead?}` (missing optional fields default to empty / false) |
| PATCH | `/emails/{id}` | `{"isRead": bool}` | `2xx` |
| DELETE | `/emails/{id}` | - | `2xx` |

Implemented by [`EmailApiService`](../../../lib/data/services/email_api_service.dart); mirrored by the
[Mock Email API](../../architecture/containers/mock-api/mock-email-api.md). There is no OpenAPI file yet: see the
[backlog](../../backlog/openapi-contract.md).
