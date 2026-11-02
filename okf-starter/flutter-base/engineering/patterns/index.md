How to write one more of something. One page per pattern the repo actually uses; copy the template.

# Choose a pattern

The starter mandates none of these. Pick per row, record the choice as an [ADR](../../adr/index.md), then add a pattern page.
Options are listed alphabetically, not ranked.

| Concern | Common options |
|---|---|
| State management and DI | Bloc / Cubit, get_it (+ any state), MobX, Provider + ChangeNotifier, Riverpod, signals, plain `ValueNotifier` |
| Navigation | auto_route, go_router, Navigator / Router API directly |
| Expected failures | exceptions with typed failures, a `Result` / `Either` type (own sealed class or a package) |
| Models and JSON | built_value, dart_mappable, freezed + json_serializable, hand-written |
| Networking | chopper, dio, http, retrofit |
| Local storage | drift, hive, shared_preferences, sqflite, secure storage for secrets |
| Test doubles | fakes, mocktail, mockito |
| Project structure | layer-first folders, feature-first folders, packages per feature |

# Concepts
* [Pattern Template](_template-pattern.md) - Copy this when documenting how to write one more of something.
