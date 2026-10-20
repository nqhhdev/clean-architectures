---
type: Component
title: "Features layer"
description: "C4 level 3 - src/features/: one folder per feature with screens and queries.ts; Emails and Home exist today."
resource: src/features
tags: [c4, components, features, tanstack-query]
status: draft
---
# Features layer

`src/features/<name>/` holds one feature each: screens, `queries.ts` and layout-only CSS Modules. A feature imports
`application/`, `domain/`, `ds/` and `app/services` only, and never another feature (K30). It never imports
`adapters/`, `locales/` or other `app/` code.

| Feature | Contents |
|---|---|
| `emails/` | `queries.ts` (`emailKeys`, `emailsQueryOptions`), `emails-screen.tsx`, `emails-screen.module.css` |
| `home/` | `home-screen.tsx` |

## Key code (C4 level 4)
```ts
const emailKeys = { all: ['emails'], list: () => [...emailKeys.all, 'list'] };
emailsQueryOptions({ emails }: Pick<Services, 'emails'>)   // queryOptions({ queryKey, queryFn })
```
* `queryFn` calls the port and, on `Err`, throws `new QueryError(result.error)`: the one place a `Result` is unwrapped
  (K11). Keys come from per-feature constants (K13).
* `emailsQueryOptions` is shared by the route loader (prefetch) and the screen (`useSuspenseQuery`), so the two cannot
  drift. The screen gets its services from `useServices()`; the loader gets them from router context (K16).
* There is no repository, view-model hook or use-case layer: the screen reads the query directly.
* User-visible text comes from translation keys (K19).

See [Emails domain](../../domains/emails/emails.md) and [Emails request flow](emails-sequence.md).
