C4 level 3 - the layers of lib/ and what each may import.

# Concepts
* [Config Layer](config.md) - Dependency injection, configuration, logging and app-wide status: the one place that picks concrete implementations.
* [Data Layer](data.md) - Repositories (source of truth, caching, mapping) over stateless services that share one ApiClient.
* [Domain Layer](domain.md) - Immutable freezed models and their error codes; pure Dart, imports only utils.
* [UI Layer](ui.md) - Feature Views and ViewModels plus ui/core (routing, theme, l10n, shared widgets) and the session screen.
* [Use Case Layer](use-cases.md) - Optional domain/use_cases: one callable class per user action, between repositories and ViewModels.
* [Utils Layer](utils.md) - Framework-free primitives every layer may use: Result, AppError, CommonErrors and the handler and logging ports.
