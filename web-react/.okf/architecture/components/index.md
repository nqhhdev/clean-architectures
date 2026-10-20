C4 level 3 - the layers inside the web SPA - and level 4: key types on each layer page and the Emails request sequence.

# Concepts
* [Components (Web SPA)](overview.md) - C4 level 3 - the layers inside the web SPA and the allowed dependency directions.
* [Adapters layer](adapters.md) - C4 level 3 - src/adapters/: the HTTP client, the Emails API adapter and mapper, session adapters, and the console logger and crash reporter.
* [App layer](app.md) - C4 level 3 - src/app/: providers, router with typed context and auth guard, query client, i18n, theme, error reporting, and app/services.
* [Application layer](application.md) - C4 level 3 - src/application/: ports (EmailsPort, SessionService, Logger, CrashReporter), the Services type, AppError and QueryError.
* [Design system layer](ds.md) - C4 level 3 - src/ds/: CSS-variable tokens with light and dark themes, Page, Stack, Inline and Heading.
* [Domain layer](domain.md) - C4 level 3 - src/domain/: Result and the Email model; pure types and functions with no imports from other layers.
* [Emails request flow](emails-sequence.md) - C4 level 4 - sequence from the /emails route through queries.ts, the port and the adapter to the API, and back as an Email list or a QueryError.
* [Features layer](features.md) - C4 level 3 - src/features/: one folder per feature with screens and queries.ts; Emails and Home exist today.
* [Locales layer](locales.md) - C4 level 3 - src/locales/: en.json, the single source of translation keys; only app/ and tests import it.
