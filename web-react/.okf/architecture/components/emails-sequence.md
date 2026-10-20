---
type: Component
title: "Emails request flow"
description: "C4 level 4 - sequence from the /emails route through queries.ts, the port and the adapter to the API, and back as an Email list or a QueryError."
resource: src/features/emails/queries.ts
tags: [c4, sequence, emails]
status: draft
---
# Emails request flow

```mermaid
sequenceDiagram
  participant R as Router loader
  participant S as EmailsScreen
  participant Q as queries.ts
  participant P as EmailsPort (emails-api)
  participant H as HttpClient
  participant A as .NET API

  R->>Q: emailsQueryOptions(context.services)
  Q->>P: list(signal)
  P->>H: get('/emails', ListEmailsResponse)
  H->>A: GET /api/emails (credentials: include)
  A-->>H: 200 JSON
  H-->>P: Ok(parsed DTOs)
  P-->>Q: Ok(Email[]) via toEmails / createEmail
  Q-->>R: cached under ['emails', 'list']
  R->>S: render
  S->>Q: useSuspenseQuery(emailsQueryOptions(useServices()))
  Note over S,Q: cache hit, no second request
```

Failure path: the HTTP client or the mapper returns `Err(AppError)`; `queryFn` throws `QueryError(appError)`; the
router's `errorComponent` (`RootError`) shows `t(errorKey(appError))` and reports the error to `CrashReporter`. A 401
also calls `onUnauthorized`, which ends the session; the guard then redirects to `/sign-in`.

Layers involved: [features](features.md), [application](application.md), [adapters](adapters.md).
