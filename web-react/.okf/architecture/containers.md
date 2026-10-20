---
type: Container
title: "Containers"
description: "C4 level 2 - the web SPA and the .NET API; test doubles are listed separately."
resource: package.json
tags: [c4, container, react]
status: draft
---
# Containers

| Container | Technology | Role | In this repo |
|---|---|---|---|
| **Web SPA** | Vite build, React 19, TypeScript; static files served by the hosting container below | Runs in the browser; talks HTTPS/JSON to the API. Sends `credentials: 'include'` and the CSRF header on non-GET API calls | Yes, `web-react/` |
| **Web hosting** | `nginx-unprivileged` container built from `web-react/Dockerfile` | Serves the built SPA as non-root on port 8080. At start the entrypoint writes `/env.js` and the nginx config (CSP with `connect-src` from `API_URL`, security headers); TLS is terminated by the platform in front ([ADR 0018](../adr/0018-ci-and-runtime-delivery.md)) | Yes, `web-react/Dockerfile` |
| **.NET API** | ASP.NET | Business data, sessions and CSRF validation ([ADR 0009](../adr/0009-cookie-session-and-csrf-owned-by-the-api.md)); validates sign-in results from the identity provider | No |
| **Identity provider** | Chosen per project | Authenticates the end user in the browser | No |

```
Browser (Web SPA) ──sign-in──> Identity provider
   │
   └──HTTPS/JSON──> .NET API ──validation only──> Identity provider
Hosting container (nginx) ──(static files, /env.js, CSP)──> Browser
```

## Test doubles (not deployed)
| Double | Technology | Used by |
|---|---|---|
| **Mock API** | MSW | Adapter tests, `pnpm dev:mock` and the e2e smoke run against the mock-mode build (`dist-mock/`, never deployed). See [ADR 0017](../adr/0017-test-harness.md) |

The SPA has no server of its own: there is no SSR and no backend-for-frontend inside this stack.
Layers inside the SPA (C4 level 3) are in [Components](components/overview.md).

## Unverified
* The sign-in redirect to the identity provider is not implemented: `/sign-in` is a placeholder screen.
