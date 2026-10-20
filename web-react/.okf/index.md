---
okf_version: "0.2"
---

The knowledge base for the React web stack, as an [Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format) v0.2 bundle: one concept per file, at a stable path. Open the `index.md` of the directory that matches your question and follow only the links you need.

# Start here

* [Understand the system](architecture/context.md) - C4 level 1 - the user, the web SPA and the external systems it depends on.
* [See what runs where](architecture/containers.md) - C4 level 2 - the web SPA and the .NET API; test doubles are listed separately.
* [See the layers](architecture/components/overview.md) - C4 level 3 - the layers inside the web SPA and the allowed dependency directions; one page per layer holds the key types.
* [Follow a request](architecture/components/emails-sequence.md) - C4 level 4 - the Emails request from route to API and back.
* [Do a task](workflows/index.md) - Build, run, test, run e2e and add a feature.
* [Learn the Emails slice](domains/index.md) - The sample slice: model, errors and layers.
* [Look up a term](glossary/index.md) - Port, Result, AppError, Services and other words used here.
* [Know the rules](engineering/constraints.md) - Numbered rules K1-K35 for layers, errors, data loading, session, i18n, tooling, tests, delivery and security, each tied to its ADR.
* [Know why it is like this](adr/index.md) - Architecture Decision Records - why the codebase is the way it is.

# Subdirectories

* [adr](adr/) - Architecture Decision Records - why the codebase is the way it is.
* [architecture](architecture/) - C4 levels 1-4: context, containers, one page per layer and the Emails request flow.
* [backlog](backlog/) - Known gaps and planned work.
* [domains](domains/) - Business slices; the Emails sample.
* [engineering](engineering/) - Rules, lint conventions and the test harness.
* [glossary](glossary/) - One file per term.
* [workflows](workflows/) - Step-by-step procedures and exact commands.

# Concepts

* [Bundle Map](map.md) - Generated - every file in this bundle with its type, description and tags, for one-read search.

# Concept types

Every concept declares exactly one of these in `type:`; the checker (`python3 .okf/tools/okf.py`) rejects anything else. Add a new value here before using it, and never a near-synonym of an existing one.

* `System Context` - C4 level 1
* `Container` - C4 level 2
* `Component` - C4 level 3, a layer
* `Mechanism` - a cross-cutting or delivery mechanism
* `Domain Slice`, `Entity`, `Value Object`, `Domain Event`, `Domain Errors` - the business model
* `ADR`, `Pattern`, `Convention`, `Constraint`, `Workflow`, `Technology`, `Term`, `Task`, `Template`, `Reference` - the remaining directories
