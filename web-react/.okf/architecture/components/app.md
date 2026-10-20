---
type: Component
title: "App layer"
description: "C4 level 3 - src/app/: providers, router with typed context and auth guard, query client, i18n, theme, error reporting, and app/services."
resource: src/app
tags: [c4, components, app, router]
status: draft
---
# App layer

`src/app/` assembles the running application. It may import every layer but holds no business rules. The two
composition roots, `src/main.tsx` (real adapters) and `src/main.mock.tsx` (MSW and a demo session), build a `Services`
object and call `mountApp(services)`; they are the only files that choose concrete adapters (K3).

| File | Contents |
|---|---|
| `bootstrap.tsx` | `mountApp(services)`: theme, global error hooks, query client, router, `StrictMode` render |
| `App.tsx` | `AppProviders` (services, i18n, query client) and `App` (router; re-runs guards when the session changes) |
| `router.tsx` | Code-based route tree and `RouterContext { queryClient, services }` |
| `route-components.tsx` | `Shell`, `RootError`, `NotFound`, `SignInPlaceholder` |
| `session-bootstrap.ts` | `bootstrapSession`: starts `session.bootstrap()` once per service (K18) |
| `query-client.ts` | `createQueryClient`, `shouldRetryQuery` (K14) |
| `i18n.ts` | `createI18n`, typed keys from `en.json` |
| `theme.ts` | `preferredTheme`, `applyTheme` |
| `error-reporting.ts` | `installGlobalErrorHandlers`: `error` and `unhandledrejection` to `CrashReporter` |
| `services/` | `ServicesContext`, `useServices()`, `useSession()`: the only `app/` path a feature may import |

## Key behaviour (C4 level 4)
* Routes: `/sign-in` (placeholder) and a pathless `shell` route whose `beforeLoad` awaits `bootstrapSession` and
  redirects to `/sign-in` when there is no user (K15). Under the shell: `/` (Home) and `/emails` (its loader prefetches
  the query with `staleTime: 'static'`).
* `RootError` (also the shell's `errorComponent`) reports the error to `CrashReporter` and shows the `errorKey` text for
  a `QueryError`, a generic message otherwise.
* Query defaults: no refetch on window focus; no retry for `refused`, `unauthorized` or `invalid`, at most two retries
  otherwise; mutations never retry ([ADR 0013](../../adr/0013-data-loading-and-routing.md)).
* `createI18n` returns a new instance per call; there is no module singleton.
