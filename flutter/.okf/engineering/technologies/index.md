Dependencies and tools, and the layer that isolates each.

# Concepts
* [Technology Template](_template-technology.md) - Copy this when adding a dependency or tool.
* [build_runner](build-runner.md) - Runs the freezed and json_serializable generators; needed after pub get and after model edits.
* [Flutter](flutter.md) - UI toolkit for iOS and Android; the stack was built with Flutter 3.38.9.
* [flutter_localizations and intl](flutter-localizations.md) - SDK localization delegates plus gen-l10n code generation from ARB files.
* [freezed](freezed.md) - Generates value equality, copyWith and toString for models, state and DTOs.
* [go_router](go-router.md) - Declarative routing with a redirect; used only in ui/core/routing and ui widgets.
* [http package](http.md) - package:http is the HTTP client, used only inside ApiClient.
* [integration_test](integration-test.md) - Flutter SDK package that runs tests in the real app on a device or simulator.
* [json_serializable](json-serializable.md) - Generates checked fromJson/toJson for DTOs in data/services/model.
* [Riverpod](riverpod.md) - flutter_riverpod 3.x provides DI and ViewModel state.
* [very_good_analysis](very-good-analysis.md) - Strict lint set behind flutter analyze, with strict-casts, strict-inference and strict-raw-types.
