---
type: Mechanism
title: "Request Lifecycle"
description: "What happens from a tap to the server and back: View, ViewModel, use case, repository, service, ApiClient."
tags: [flow, request]
status: stable
---
# Request Lifecycle

```
tap on a row (EmailTile)
  -> EmailsScreen calls EmailsViewModel.toggleRead(email)      ignored if another action is in flight
  -> ToggleEmailReadUseCase -> EmailRepository.setRead(id, isRead)
  -> EmailRepositoryRemote -> EmailApiService.setRead -> ApiClient.patchJson  (PATCH /emails/{id})
  -> ApiClient.onResponse clears offline (any response) and session-expired (2xx)
  -> on success the repository refetches (GET /emails), maps DTOs, fills its cache
  -> ViewModel reloads through ListEmailsUseCase (newest first), checks ref.mounted, sets EmailsState
  -> EmailsScreen rebuilds from the new state
```
On failure `ApiClient` throws `ApiException`; the repository returns `Failure(AppError)`; the ViewModel asks the urgent
failure handler and either the banner / sign-in redirect appears (urgent) or the list stays with `EmailsState.error` and Retry.
See [Error Handling](error-handling.md) and [ADR 0019](../../adr/0019-urgent-failure-clearing-and-async-rules.md).
