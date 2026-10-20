---
type: Workflow
title: "Run the app"
description: "Start the dev server against a real API, or in mock mode with MSW and a signed-in demo user."
tags: [workflow, run, mock-mode]
status: draft
---
# Run the app

From `web-react/`, after `pnpm install`:

| Goal | Command | Notes |
|---|---|---|
| Mock mode (no backend) | `pnpm dev:mock` | `src/main.mock.tsx`: MSW answers `/api/emails`, signed-in `Demo user` |
| Real API | `pnpm dev` | `src/main.tsx`: requests go to `/api` on the same origin; the Vite dev server has no proxy configured, so serve the API behind the same origin or add one |
| Built mock bundle | `pnpm build:mock` then `pnpm exec vite preview --mode mock` | What the e2e test runs; output in `dist-mock/` |
| Production build | `pnpm build` then `pnpm preview` | Output in `dist/`; no MSW |

* Routes: `/` (Home), `/emails`, `/sign-in` (placeholder). Without a session the guard redirects to `/sign-in`; the real
  composition root starts signed out until `GET /session` answers.
* Mock data lives in `src/main.mock.tsx`; the worker file is `public-mock/mockServiceWorker.js`.
* The theme follows the OS (`prefers-color-scheme`).
