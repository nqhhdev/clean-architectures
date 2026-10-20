# web-react

A React 19 + strict TypeScript starter with hexagonal layers enforced by lint, a generated API client, and an `Emails` example slice. Stack: Vite, TanStack Router and Query, zod, i18next, Vitest, MSW and Playwright. Knowledge base: [`.okf/`](.okf/index.md) (architecture, ADRs, constraints, workflows).

## Quick start

Requires Node 26 (see `.nvmrc`) and pnpm 12.14.0 (the `packageManager` field; Node 25+ has no corepack).

```sh
npm install -g pnpm@12.14.0   # once; Node 25+ has no corepack
pnpm install
pnpm dev:mock      # no backend needed: MSW answers the API, signed in as a demo user
pnpm check         # the gate CI runs
```

`pnpm dev` runs against a real API at `/api` on the same origin; the dev server has no proxy configured.

## Scripts

| Script                              | What it does                                                                                                               |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `pnpm dev` / `pnpm dev:mock`        | Vite dev server with the real or the mock entry                                                                            |
| `pnpm build` / `pnpm build:mock`    | Type-check and build to `dist/`; mock build to `dist-mock/`                                                                |
| `pnpm preview`                      | Serve the last build                                                                                                       |
| `pnpm generate`                     | Generate types, zod schemas and MSW handlers from `openapi/emails.yaml` into the git-ignored `src/adapters/api/generated/` |
| `pnpm lint` / `pnpm typecheck`      | ESLint (including layer boundaries) / `tsc --noEmit`                                                                       |
| `pnpm format` / `pnpm format:check` | Prettier write / check                                                                                                     |
| `pnpm test` / `pnpm test:coverage`  | Vitest; coverage fails below 80% lines                                                                                     |
| `pnpm check`                        | generate, format check, lint, typecheck, coverage, build, bundle check, secret scan, `.okf` check                          |
| `pnpm e2e:install` / `pnpm e2e`     | Install chromium once / build the mock bundle and run the Playwright smoke test (not part of `pnpm check`)                 |
| `pnpm okf`                          | Check the knowledge base (`python3 .okf/tools/okf.py` also regenerates `.okf/map.md`)                                      |

## Mock mode

`--mode mock` runs `src/main.mock.tsx` instead of `src/main.tsx`: the same app and the same API adapter, with MSW answering the requests and an in-memory signed-in session. Seed data is in `src/main.mock.tsx`; the worker script is in `public-mock/`. Mock builds go to `dist-mock/`, so the production `dist/` never contains MSW (`pnpm check:bundle` verifies it). The e2e test runs against the mock build.

## Layout

```
src/domain        types and pure functions (Result, Email)
src/application   ports, AppError, Services
src/adapters      HTTP client, API adapters, session, telemetry
src/ds            tokens and layout components
src/features      screens and queries.ts, one folder per feature
src/app           providers, router, query client, i18n
src/locales       en.json
src/main.tsx      real composition root      src/main.mock.tsx  mock composition root
```

Allowed imports are in the [components overview](.okf/architecture/components/overview.md); `pnpm lint` fails on any other edge.

## Add a feature

Follow [Add a feature](.okf/workflows/engineering/add-a-feature.md). In short: add the endpoint to `openapi/emails.yaml` and run `pnpm generate`; a domain type; a port in `application/` and its entry in `Services`; an adapter and mapper in `adapters/api/`; wire it in both composition roots; a fake in `src/test/fakes/`; then `src/features/<name>/` with `queries.ts` and the screen, a route in `src/app/router.tsx`, strings in `src/locales/en.json`, and tests. Run `pnpm check`.

## CI

`.github/workflows/web-react.yml` runs on pushes to `main`, pull requests and the merge queue, only when `web-react/` changed: `pnpm audit --prod --audit-level=high` and `pnpm check`, then, on pull requests to `main`, the Playwright job. The `gate` job is the only required status check. Dependabot opens weekly npm updates.

## Deploy

One image serves every environment; nothing is configured at build time. The image is `nginx-unprivileged` (non-root, port 8080) and its entrypoint (`docker/entrypoint.sh`) writes `/env.js` and the nginx config, including the CSP and the other security headers, from environment variables when the container starts.

```sh
docker build -t web-react .
docker run --rm -p 8080:8080 -e API_URL=https://api.example.com web-react
```

| Variable  | Required | Meaning                                                                                                                                                                           |
| --------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `API_URL` | yes      | Base URL of the API: `https://...`, or a same-origin path such as `/api`. Plain `http://` is accepted only for `localhost`, `127.0.0.1`, `[::1]` and `*.localhost`. Public value. |

The CSP `connect-src` is `'self'` plus the origin of `API_URL`, so it cannot drift from the value the app uses. A missing or invalid `API_URL` stops the container at start, and the app also refuses to boot (an error page) if `/env.js` is missing or invalid. TLS is expected to be terminated by the platform in front of the container. `/healthz` returns 200.

For `pnpm dev`, `API_URL` is not read: set `VITE_API_URL` (default `/api`). Mock mode has no runtime config. Tests: `src/app/runtime-config.test.ts` (parser) and `docker/entrypoint.test.mjs` (env.js, CSP and headers).
