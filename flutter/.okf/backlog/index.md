Known gaps. Each file is a `Task` with `status: draft`; delete it when done and log it.

# Concepts
* [Android verification](android-verification.md) - The dev flavor APK builds; running the app and e2e on an emulator against 10.0.2.2 is unverified.
* [OpenAPI contract](openapi-contract.md) - There is no machine-readable API contract; the REST surface is described only in prose.
* [Patrol for native e2e](patrol-e2e.md) - integration_test cannot drive permissions dialogs, notifications or webviews.
* [Persistent cache](persistent-cache.md) - The repository cache is memory only, so every launch refetches.
* [Real authentication flow](real-auth-flow.md) - A 401 redirects to a placeholder sign-in screen; there is no real sign-in, token storage or refresh.
* [Security baseline enforcement](security-baseline-enforcement.md) - Build the code and CI checks that enforce ADR 0020 rules S1-S7; today they are review-only.
* [riverpod_lint](riverpod-lint.md) - riverpod_lint is not installed; an architecture-test stand-in catches only ref.read inside build().
