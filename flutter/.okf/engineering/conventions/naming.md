---
type: Convention
title: "Naming and Placement"
description: "Where every kind of file lives and what it is called - one table, one row per kind."
tags: [convention, naming, placement]
status: stable
---
# Naming and Placement

| Kind | Location | Name |
|---|---|---|
| View | `lib/ui/<feature>/` | `<feature>_screen.dart`, class `<Feature>Screen` |
| ViewModel | `lib/ui/<feature>/` | `<feature>_view_model.dart`, `<Feature>ViewModel`, provider `<feature>ViewModelProvider` |
| UI state | with its ViewModel | `<Feature>State`, immutable |
| Feature widget (row, card) | `lib/ui/<feature>/` | by role, e.g. `email_tile.dart`, `EmailTile` |
| Shared widget | `lib/ui/core/` | by role, avoid names that clash with the Flutter SDK |
| Theme, routing, l10n | `lib/ui/core/theme/`, `routing/`, `l10n/` | `app_theme.dart`, `app_router.dart`, `app_<locale>.arb` |
| Domain model | `lib/domain/models/` | `<model>.dart`, `<Model>` |
| Domain errors | `lib/domain/errors/` | `<feature>_errors.dart`, `<Feature>Errors` |
| Common errors, ports | `lib/utils/` | `common_errors.dart`, `logger.dart` |
| Use case | `lib/domain/use_cases/` | `<verb>_<noun>_use_case.dart`, `<Verb><Noun>UseCase` |
| Repository interface | `lib/data/repositories/<feature>/` | `<feature>_repository.dart`, `<Feature>Repository` |
| Repository implementation | same folder | `<feature>_repository_remote.dart` / `_local.dart`, `<Feature>RepositoryRemote` / `Local` |
| Mapper | same folder | `<model>_mapper.dart`, function `<model>FromDto` |
| Service | `lib/data/services/` | `<feature>_api_service.dart`, `<Feature>ApiService` |
| Wire model | `lib/data/services/model/` | `<model>_dto.dart`, `<Model>Dto` |
| Providers (DI) | `lib/config/providers/` | `core_providers.dart`, `<feature>_providers.dart`; `<thing>Provider` |
| Env file | `env/` | `dev.json`, `stg.json`, `prod.json` |
| Test | mirrors `lib/` under `test/` | `<file>_test.dart`; goldens in `goldens/` next to the test |
| Robot | `integration_test/robots/` | `<screen>_robot.dart`, `<Screen>Robot` |

Enforced: placement by the layer test; file/class suffixes by the naming rule ([Constraints](../constraints.md)); other names by review.
