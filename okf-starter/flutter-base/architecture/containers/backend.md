---
type: Container
title: "Backend"
description: "C4 level 2 - the server or services the app depends on, as seen from the app."
tags: [c4, container, backend]
status: draft
---
# Backend

`<Name, owner team, base URLs per environment, API style (REST / GraphQL / gRPC), where the contract lives.>`

| Environment | Base URL | Notes |
|---|---|---|
| `<dev>` | `<...>` | `<mock / shared>` |
| `<prod>` | `<...>` | |

Add one page per further container (mock server, worker, web admin) and list it in [Containers](index.md).
