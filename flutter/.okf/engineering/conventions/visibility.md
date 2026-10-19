---
type: Convention
title: "Visibility"
description: "Dart has library-private names only; implementation classes are kept out of the UI by the import rule, not by access modifiers."
tags: [convention, visibility]
status: stable
---
# Visibility

The .NET template makes implementations `internal`. Dart has no package-internal level, so:

* Use `_name` for things private to a file.
* Keep implementation classes in `*_remote.dart` / `*_local.dart` and let the layer test forbid importing them outside `config/`.
* Expose abstractions (`EmailRepository`) to `ui/`, never the implementation.

Enforced: [Layered Architecture](../../architecture/cross-cutting/layered-architecture.md).
