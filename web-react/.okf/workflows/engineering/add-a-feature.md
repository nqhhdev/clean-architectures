---
type: Workflow
title: "Add a feature"
description: "Steps to add a resource and screen: contract, domain, port, adapter, queries.ts, screen, route, strings, fake and tests."
tags: [workflow, feature, emails]
status: draft
---
# Add a feature

Copy the Emails slice (`domain/email.ts`, `application/emails.ts`, `adapters/api/emails-api.ts`, `features/emails/`);
the layer rules are in [Components](../../architecture/components/overview.md). Run `pnpm check` after each numbered step
that changes code.

1. **Contract.** Add the path and schemas to `openapi/emails.yaml` (or the replacement spec, [ADR 0008](../../adr/0008-openapi-contract-as-single-schema-source.md)), then `pnpm generate`. Output lands in the git-ignored `src/adapters/api/generated/`.
2. **Domain.** Add the type and, if input needs validation, a constructor returning `Result<T, YourInvalid>` in `src/domain/<name>.ts`, with a unit test.
3. **Port.** Add `src/application/<name>.ts` with one port per resource returning `Promise<Result<T, AppError>>`; add it to `Services` in `services.ts`.
4. **Adapter.** Add `src/adapters/api/<name>-api.ts` and a mapper from the generated DTO to the domain type. A DTO the model rejects is `invalid`. Test it with MSW and the generated handler.
5. **Composition roots.** Build the adapter in `src/main.tsx`; in `src/main.mock.tsx` build it over the same HTTP client and add seed data to the MSW worker.
6. **Fake.** Add `src/test/fakes/<name>.ts` and include it in `createFakeServices`.
7. **Feature.** Create `src/features/<name>/` with `queries.ts` (key constants, `queryOptions` that throw `QueryError` on `Err`) and the screen. Layout CSS goes in a `*.module.css`; colours, type and spacing come from `ds/` variables. No import from another feature.
8. **Route.** Add the route under the `shell` route in `src/app/router.tsx`; prefetch in its `loader` from `context.services`. Add a nav link in `Shell` if needed.
9. **Strings.** Add every visible string to `src/locales/en.json` and use `t('...')`.
10. **Tests.** A component test with `renderWithProviders` and a fake port; a `queries.test.ts`; extend the e2e smoke test only for a new user-visible path.
11. **Knowledge base.** Add or update the layer pages, a domain page under `.okf/domains/`, and a line in `.okf/log.md`; run `pnpm okf`.

If the feature needs a new top-level `src/` folder, add the boundaries element and matrix row first (K7).
