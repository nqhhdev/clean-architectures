How to write one more of something, with copyable shapes.

# Concepts
* [Pattern Template](_template-pattern.md) - Copy this when documenting how to write one more of something.
* [Build-Time Configuration](build-time-configuration.md) - A setting is a key in env/*.json, parsed once in AppConfig.resolve and injected through appConfigProvider.
* [Cached Read](cached-read.md) - Read from an in-memory cache first; refresh on demand and after writes; keep the old cache when a refresh fails.
* [Entity Factory Method](entity-factory-method.md) - Domain models are freezed classes with a private constructor and a validated static create that returns a Result.
* [Fake over Mock](fake-over-mock.md) - Test with small hand-written fakes that implement the interface rather than a mocking framework.
* [Repository](repository.md) - An abstract interface in data/repositories with a remote implementation over a service, a mapper and an in-memory cache.
* [Test Robot](test-robot.md) - E2E tests talk to a robot class that hides keys and finders, so tests read as user actions.
* [Urgent Failure Handling](urgent-failure-handling.md) - Ask the UrgentFailureHandler first on every repository failure; skip your own error UI when it handled it.
* [View Model](view-model.md) - An AsyncNotifier with an immutable state class holds a screen logic; the View only renders and forwards events.
