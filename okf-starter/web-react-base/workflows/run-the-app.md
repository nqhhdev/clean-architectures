---
type: Workflow
title: "Run the App"
description: "Run the web app locally per environment or mode, with the matching config and backend."
tags: [workflow, run, environment]
status: draft
---
# Run the App

| Mode | Command | Config | Backend |
|---|---|---|---|
| `<dev>` | `<pm> run dev` | `<.env.development>` | `<local / proxy>` |
| `<mock>` | `<pm> run dev:mock` | `<...>` | `<in-browser mock>` |
| `<preview>` | `<pm> run build && <pm> run preview` | `<...>` | `<...>` |

**Choose** how config reaches the client: build-time env variables, a runtime config file served with the app, or both.
Anything shipped to the browser is public; never put secrets there. See [Constraints](../engineering/constraints.md).
