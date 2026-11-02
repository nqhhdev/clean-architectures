---
type: System Context
title: "System Context"
description: "C4 level 1 - what this web app is, who uses it, and which external systems it depends on."
tags: [c4, context, web]
status: draft
---
# System Context

## The system
`<One paragraph: what the web app does, for whom; SPA, SSR or static; which browsers.>`

## Who uses it
| Actor | Interaction |
|---|---|
| `<End user>` | Uses the [Web App](containers/web-app.md) in a browser |
| `<Admin / support / other>` | `<how>` |

## External systems
| System | Role | Status |
|---|---|---|
| `<Backend API>` | `<source of truth for ...>`, see [Backend](containers/backend.md) | `<exists / planned / mocked>` |
| `<Identity provider>` | `<sessions, SSO>` | `<...>` |
| `<Analytics, error monitoring, CDN>` | `<...>` | `<...>` |

## Boundaries
`<Which folders of the repo are this system; what is out of scope.>`
