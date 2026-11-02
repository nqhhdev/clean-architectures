---
type: System Context
title: "System Context"
description: "C4 level 1 - what this app is, who uses it, and which external systems it depends on."
tags: [c4, context, flutter]
status: draft
---
# System Context

## The system
`<One paragraph: what the app does, for whom, on which platforms (iOS, Android, web, desktop).>`

## Who uses it
| Actor | Interaction |
|---|---|
| `<End user>` | Uses the [App](containers/app.md) |
| `<Admin / support / other>` | `<how>` |

## External systems
| System | Role | Status |
|---|---|---|
| `<Backend API>` | `<source of truth for ...>`, see [Backend](containers/backend.md) | `<exists / planned / mocked>` |
| `<Identity provider>` | `<issues sessions>` | `<...>` |
| `<Push, analytics, crash reporting>` | `<...>` | `<...>` |

## Boundaries
`<Which folders of the repo are this system; what is out of scope.>`
