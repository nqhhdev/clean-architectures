---
type: Workflow
title: "Add a Feature"
description: "The end-to-end procedure for adding a vertical slice across every layer."
tags: [workflow, feature, slice]
status: stable
---
# Add a Feature

For feature `foo`, create what it needs in each layer (copy the Emails slice; names: [Naming and Placement](../../engineering/conventions/naming.md)):

1. `domain/models/foo.dart` (freezed) + `domain/errors/foo_errors.dart` - [Entity Factory Method](../../engineering/patterns/entity-factory-method.md).
2. `data/services/foo_api_service.dart` over `ApiClient` + `model/foo_dto.dart` when it talks to a server.
3. `data/repositories/foo/foo_repository.dart`, `foo_mapper.dart`, `foo_repository_remote.dart` - [Repository](../../engineering/patterns/repository.md).
4. `domain/use_cases/<verb>_foo_use_case.dart` when there is logic to own ([Use Case Layer](../../architecture/components/use-cases.md)).
5. `config/providers/foo_providers.dart`.
6. `ui/foo/foo_view_model.dart`, `foo_screen.dart`, a route in `app_router.dart`, ARB strings and `errorMessage` arms - [View Model](../../engineering/patterns/view-model.md).
7. `dart run build_runner build -d`.
8. Tests mirroring `lib/`: model, service, repository, use case, ViewModel, screen, one integration scenario; e2e for key flows.
9. Update `.okf/`: a domain page, a Constraint row if a rule changed, the [log](../../log.md); run `python3 .okf/tools/okf.py`.

**Verify:** [Build and Test](build-and-test.md).
