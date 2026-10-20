---
type: Task
title: "Realtime live port"
description: "Optional SSE-over-fetch live port in application/ with an adapter in adapters/live/, built only when a feature needs server push."
tags: [backlog, realtime]
status: draft
---
# Realtime live port

**Problem.** No feature needs server push today. If one does, the layers of
[ADR 0010](../adr/0010-hexagonal-layers-boundaries-and-services.md) already reserve a place for it: a `live` port in
`application/` and an adapter in `adapters/live/`, using server-sent events over `fetch` so the session cookie
([ADR 0009](../adr/0009-cookie-session-and-csrf-owned-by-the-api.md)) is sent like any other request.

**Constraints when built.**
* Starting the connection is idempotent under React `StrictMode` double start (K18 in [constraints](../engineering/constraints.md)).
* A 401 on the stream goes through the same single handler as other requests ([ADR 0014](../adr/0014-session-and-single-401-handler.md)).
* Updates reach the UI by writing to or invalidating the query cache ([ADR 0003](../adr/0003-state-management.md)), not through a second store.
* The CSP `connect-src` already matches the API URL ([ADR 0018](../adr/0018-ci-and-runtime-delivery.md)).

**Done when** a feature needs it, an ADR records the transport choice, the port, adapter, fake and MSW handler exist
with tests, and this file is deleted and logged. Until then nothing here is decided beyond the placement.
