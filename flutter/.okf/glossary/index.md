One file per term. Each section groups terms by subject (the first tag).

# architecture
* [Composition Root](composition-root.md) - The only place that chooses concrete implementations: config/providers/ and main.dart.
* [Port](port.md) - An interface in utils/ (Logger, CrashReporter, UrgentFailureHandler) whose implementation config/ chooses.
* [Repository](repository.md) - The source of truth for one kind of data; hides services and caching behind an interface.
* [Service](service.md) - A stateless wrapper over one data source such as a REST API.
* [Source of Truth](source-of-truth.md) - The single place that owns a piece of data or state; everything else reads it.
* [Use Case](use-case.md) - A callable domain class for one user action, sitting between repositories and ViewModels.
* [View Model](view-model.md) - The object that holds a screen logic and state and exposes actions; here an AsyncNotifier.

# configuration
* [Flavor](flavor.md) - A native build variant (dev, stg, prod) paired with the env JSON file of the same name.

# data
* [Cache-First](cache-first.md) - Reads are served from the repository cache; writes are followed by a refetch.
* [DTO](dto.md) - The wire format of a model, kept separate from the domain model.

# errors
* [AppError](app-error.md) - A typed failure with a Feature.Reason code and an ErrorType; it carries no message.
* [Result](result.md) - A value that is either Success(value) or Failure(AppError); expected failures are returned, not thrown.
* [Urgent Failure](urgent-failure.md) - A failure (expired session, no network) handled app-wide before any screen shows its own error.

# state
* [In-Flight Guard](in-flight-guard.md) - A ViewModel flag that ignores new actions while one is still running.
* [Notifier](notifier.md) - A Riverpod class that owns mutable state and exposes methods that change it.
* [Provider](provider.md) - A Riverpod object that creates and exposes a value; overridden in tests to swap implementations.

# templates
* [Term Template](_template-term.md) - Copy this when adding a glossary entry.

# testing
* [Architecture Test](architecture-test.md) - A test that fails when code breaks a layer rule, instead of leaving it to review.
* [Fake](fake.md) - A small hand-written implementation of an interface used instead of a mock framework.
* [Mock API](mock-api.md) - The in-memory stand-in for the backend used by integration and e2e tests.
* [Robot](robot.md) - A class that hides finders and keys so e2e tests read as user actions.
