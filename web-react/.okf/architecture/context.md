---
type: System Context
title: "System Context"
description: "C4 level 1 - the user, the web SPA and the external systems it depends on."
resource: package.json
tags: [c4, context, react]
status: draft
---
# System Context

## The system
A **single-page web app** (React, TypeScript) built as a clean-architecture starter. The business capability is yours
to add; the starter will ship one example slice, Emails, served by the same REST surface as the Flutter stack. An
OpenAPI file for that surface is planned ([ADR 0008](../adr/0008-openapi-contract-as-single-schema-source.md)).

## Who uses it
| Actor | Interaction |
|---|---|
| **End user** | Uses the [web SPA](containers.md) in a browser; signs in with the identity provider |
| **Developer** | Builds on the starter; reads this bundle first |

## External systems
| System | Role | Status |
|---|---|---|
| **.NET API** | Source of truth for emails over HTTPS/JSON | Not in this repo. Contract: [ADR 0008](../adr/0008-openapi-contract-as-single-schema-source.md) |
| **Identity provider** | Authenticates the end user; the API validates the result and issues the session | Placeholder until each project picks one; cookie issuing is the API's job ([ADR 0009](../adr/0009-cookie-session-and-csrf-owned-by-the-api.md)) |

## Relationships
* End user -> Web SPA: uses in a browser.
* End user -> Identity provider: signs in.
* Web SPA -> .NET API: HTTPS/JSON.
* .NET API -> Identity provider: validates sign-in results only.

## Boundaries
Everything under `web-react/` is this system. Other stacks in the monorepo have their own folders and bundles.

## Unverified
* The REST surface shared with Flutter is not yet written down as an OpenAPI file (planned, step 4).
* The identity provider, sign-in flow and session cookie behaviour are not chosen or implemented.
