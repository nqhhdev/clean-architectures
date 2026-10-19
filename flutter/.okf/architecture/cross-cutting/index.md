Mechanisms that cut across layers: layering, slices, request flow, errors, caching, state, navigation, l10n, theming, config, API, security.

# Concepts
* [API Surface](api-surface.md) - The REST contract the app consumes: three endpoints on /emails.
* [Background Processing](background-processing.md) - Work outside the foreground UI (push, background sync); none in the starter.
* [Caching](caching.md) - The repository keeps an in-memory cache; reads are cache-first and every write is followed by a refetch.
* [Configuration and Environments](configuration.md) - dev, stg and prod are env JSON files plus native flavors; AppConfig resolves them once at startup.
* [Error Handling](error-handling.md) - How failures travel: ApiException in services, Result with AppError codes above, urgent routing and localized text in the UI.
* [Layered Architecture](layered-architecture.md) - The layers of lib/ and the single direction in which imports may point.
* [Localization](localization.md) - User-facing text comes from ARB files through gen-l10n; error codes are mapped to text in the UI.
* [Navigation](navigation.md) - go_router routes in ui/core/routing; an expired session redirects to sign-in and back.
* [Observability](observability.md) - Logger and CrashReporter ports with console defaults; global hooks route every escaped error. No tracing or backend.
* [Persistence](persistence.md) - Local storage of data across launches; the starter keeps everything in memory.
* [Request Lifecycle](request-lifecycle.md) - What happens from a tap to the server and back: View, ViewModel, use case, repository, service, ApiClient.
* [Security and Authorization](security-and-authorization.md) - The universal security baseline and its current state, plus project-specific choices each project must fill in.
* [State Management](state-management.md) - Riverpod notifiers own state; providers in config/providers pick implementations; each shared state has one owner.
* [Theming](theming.md) - AppTheme builds light and dark Material 3 themes from one seed, with ThemeExtensions for app-specific styles.
* [Vertical Slice Architecture](vertical-slice-architecture.md) - A feature spans every layer; each layer keeps a folder or file named after the feature.
