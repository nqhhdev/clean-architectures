---
type: Container
title: "Backend"
description: "C4 level 2 - the server or services the web app depends on, as seen from the client."
tags: [c4, container, backend]
status: draft
---
# Backend

`<Name, owner team, base URLs per environment, API style (REST / GraphQL / gRPC-web), where the contract lives (OpenAPI, schema).>`

| Environment | Base URL | Notes |
|---|---|---|
| `<local>` | `<...>` | `<mock / proxy>` |
| `<prod>` | `<...>` | |

Add one page per further container (mock server, BFF, worker) and list it in [Containers](index.md).
