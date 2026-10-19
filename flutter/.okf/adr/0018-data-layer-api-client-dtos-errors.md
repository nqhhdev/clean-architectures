---
type: ADR
title: "ADR 0018: One ApiClient, DTO services and mapped errors in the data layer"
description: "ApiClient owns HTTP; services return DTOs; repositories map DTOs and ApiException to domain, skipping invalid items."
tags: [adr, data, http, errors]
status: stable
---
# ADR 0018: One ApiClient, DTO services and mapped errors in the data layer

**Status:** Accepted - 2026-10-19. Refines [ADR 0002](0002-result-over-exceptions.md) and [ADR 0006](0006-ui-reads-from-repository-cache.md).

## Context
Each service would repeat base URL, headers, timeouts and status mapping, and one invalid row in a list failed the whole inbox.

## Decision
* [`ApiClient`](../../lib/data/services/api_client.dart) is the only user of `package:http`: base URL, headers, bearer token, timeout,
  retry of GET/DELETE on network or 502/503/504 (PATCH never), status-to-`ApiFailure` mapping, logging, `onResponse` observer.
* Services ([`EmailApiService`](../../lib/data/services/email_api_service.dart)) are stateless, return DTOs, and turn any parse error
  into `ApiException(ApiFailure.malformed)` with cause and stack.
* Repositories map DTOs with a mapper ([`email_mapper.dart`](../../lib/data/repositories/emails/email_mapper.dart)) and exceptions with
  [`appErrorFromApi`](../../lib/data/repositories/api_error_mapper.dart) to [`CommonErrors`](../../lib/utils/common_errors.dart) or a feature error.
* A list skips and logs items that fail domain validation; a malformed payload fails the call with `Common.Server`.

## Consequences
**Good.** One place for transport policy; tested in [`api_client_test.dart`](../../test/data/services/api_client_test.dart) and
[`email_repository_remote_test.dart`](../../test/data/repositories/emails/email_repository_remote_test.dart).
**Costly.** Skipped items are only visible in logs.
**Alternatives rejected.** Dio with interceptors (another dependency for what `ApiClient` does); failing the whole list on one bad item.

## When to revisit
When an OpenAPI contract allows generated clients ([backlog](../backlog/openapi-contract.md)).
