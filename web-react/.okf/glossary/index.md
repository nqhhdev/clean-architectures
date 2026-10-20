One file per term. Each section groups terms by subject (the first tag).

# architecture
* [Composition Root](composition-root.md) - main.tsx or main.mock.tsx: the only files that choose concrete adapters and build Services.
* [Port](port.md) - An interface in application/ (EmailsPort, SessionService, Logger, CrashReporter) that an adapter implements and a composition root wires.
* [Services](services.md) - The object of ports a composition root builds, put in ServicesContext and read with useServices() or from router context.

# data
* [DTO](dto.md) - The wire shape of a model, as a type and zod schema generated from the OpenAPI file; a mapper turns it into a domain type.

# errors
* [AppError](app-error.md) - A failure with one of four kinds (refused, unauthorized, network, invalid), an optional status and code, and no message text.
* [QueryError](query-error.md) - The Error that queries.ts throws for an Err result, because TanStack Query needs a thrown error; it carries the AppError.
* [Result](result.md) - A value that is either Ok(value) or Err(error); expected failures are returned, not thrown.

# testing
* [Fake](fake.md) - A small hand-written implementation of a port used in component tests instead of a mock framework.
* [Layer Rule Test](layer-rule-test.md) - A Vitest test that lints one fixture file per forbidden import edge, so a loosened boundaries rule fails a test.
* [Mock Mode](mock-mode.md) - A Vite mode (--mode mock) that runs src/main.mock.tsx with MSW answering for the API and a signed-in demo user; built into dist-mock/.
