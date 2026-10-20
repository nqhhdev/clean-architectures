Rules the code must follow, with the ADR behind each, and the conventions the tooling enforces.

# Concepts
* [Architecture constraints](constraints.md) - Numbered rules K1-K35 for layers, errors, data loading, session, i18n, tooling, tests, delivery and security, each tied to its ADR.
* [Lint and compiler rules](lint-rules.md) - What eslint.config.js, the boundaries and security configs, and tsconfig enforce, how to add an exception, and where each rule is tested.
* [Test harness](test-harness.md) - The four test tiers as built: Vitest unit and component tests, MSW adapter tests, fakes per port, renderWithProviders, and the Playwright smoke test on the mock build.
