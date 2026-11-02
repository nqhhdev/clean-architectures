---
type: Convention
title: "Naming and Placement"
description: "Where each kind of file lives and what it is called - one table, one row per kind."
tags: [convention, naming]
status: draft
---
# Naming and Placement

Dart files are `snake_case.dart`, types `UpperCamelCase`, members `lowerCamelCase` ([Effective Dart](https://dart.dev/effective-dart/style)).
Fill the table from the real repo; one row per kind of file.

| Kind | Folder | File | Class |
|---|---|---|---|
| Screen | `<lib/ui/<feature>/>` | `<x_screen.dart>` | `<XScreen>` |
| State holder | `<...>` | `<x_view_model.dart / x_bloc.dart / x_controller.dart>` | `<...>` |
| Model | `<lib/domain/models/>` | `<x.dart>` | `<X>` |
| Repository | `<lib/data/repositories/>` | `<x_repository.dart>` | `<XRepository>` |
| Service / API client | `<lib/data/services/>` | `<x_service.dart>` | `<XService>` |
| Test | `test/` mirroring `lib/` | `<x_test.dart>` | |

Imports: **choose** package imports or relative imports inside `lib/`, and enforce it with the matching lint.
