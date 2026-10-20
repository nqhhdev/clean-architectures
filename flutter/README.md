# flutter

Clean-architecture starter for Flutter (iOS + Android), following the official
[app architecture guide](https://docs.flutter.dev/app-architecture) with Riverpod, freezed and go_router. See
[`.okf/index.md`](.okf/index.md) for the knowledge base (rules, ADRs, workflows).

```
lib/
  main.dart, app.dart          entry point (config, error hooks) and root widget
  ui/
    core/                      theme/, routing/, l10n/ (ARB + generated), banner, error widget
    <feature>/                 <feature>_screen, <feature>_view_model, row widgets
  domain/
    models/                    freezed models, validated create()
    errors/                    error codes per feature
    use_cases/                 optional use cases
  data/
    repositories/<feature>/    abstract repository, *_remote.dart, mapper
    services/                  api_client.dart, <feature>_api_service.dart, model/ (DTOs)
  config/
    env.dart                   AppConfig from env/*.json
    providers/                 core_providers.dart, <feature>_providers.dart
    app_status.dart, logging.dart, error_hooks.dart
  utils/                       Result, AppError, CommonErrors, Logger/CrashReporter ports
env/                           dev.json, stg.json, prod.json (--dart-define-from-file)
test/                          mirrors lib/ + architecture/, support/, integration/
integration_test/              device e2e with robots
tool/                          mock API server, coverage check
```

## Getting started

```bash
flutter pub get && dart run build_runner build -d      # generated code is git-ignored
dart run tool/mock_server.dart                         # terminal 1: backend on 127.0.0.1:8080
flutter run --flavor dev --dart-define-from-file=env/dev.json   # terminal 2
flutter test --exclude-tags golden                     # on macOS; goldens are Linux/CI canonical
```

Flavors: `dev`, `stg`, `prod` on Android (`productFlavors`) and iOS (schemes and `Debug-<flavor>` configurations).
Release builds fail fast when `ENV` or `API_BASE_URL` is missing; prod requires https.

`Emails` (an inbox that lists, marks read/unread and deletes) is the example feature, with tests at every tier. Replace it with your domain
(rename the package and ids by hand, see the Extending the Template page).
