---
okf_version: "0.2"
---

The knowledge base for the Flutter stack, as an [Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format) v0.2 bundle: one concept per file, at a stable path. Open the `index.md` of the directory that matches your question and follow only the links you need - every index is a filter, not a summary. If you learn something durable about this codebase, write it here (see [Maintain the Knowledge Base](workflows/process/maintain-the-knowledge-base.md)), not into a comment.

Pages marked `status: draft` are placeholders that keep the standard layout; fill them in once the real project is scanned.

# Start here

* [Understand the system](architecture/context.md) - C4 level 1 - what this app is, who uses it, and which external systems it depends on.
* [Add a feature](workflows/engineering/add-a-feature.md) - The end-to-end procedure for adding a vertical slice across every layer.
* [Know where a new file goes and what to call it](engineering/conventions/naming.md) - Where every kind of file lives and what it is called - one table, one row per kind.
* [Not break anything](engineering/constraints.md) - Every rule the code must keep, what enforces it, and the page that owns the reasoning - re-check before you finish.
* [Know why it is like this](adr/index.md) - Architecture Decision Records - why the codebase is the way it is.
* [Something is wrong](troubleshooting.md) - Common failure symptoms in this stack, each mapped to its likely cause and the concept that explains it.
* [Build a product from this starter](workflows/process/extending-the-template.md) - How to turn this starter into a real product and grow the knowledge base with it.

# Subdirectories

* [adr](adr/) - Architecture Decision Records - why the codebase is the way it is.
* [architecture](architecture/) - C4 levels 1-3 (context, containers, components), cross-cutting mechanisms and delivery.
* [backlog](backlog/) - Known gaps and planned work.
* [domains](domains/) - The business model - one folder per domain slice with its entities and errors.
* [engineering](engineering/) - Code-level detail: patterns, technologies, conventions and the constraints table.
* [glossary](glossary/) - One file per term, tagged by subject.
* [references](references/) - External material this bundle draws on.
* [workflows](workflows/) - Step-by-step procedures and exact commands, by area.

# Concepts

* [Bundle Map](map.md) - Generated - every file in this bundle with its type, description and tags, for one-read search.
* [Troubleshooting by Symptom](troubleshooting.md) - Common failure symptoms in this stack, each mapped to its likely cause and the concept that explains it.

# Concept types

Every concept declares exactly one of these in `type:`; the checker (`python3 .okf/tools/okf.py`) rejects anything else. Add a new value here before using it, and never a near-synonym of an existing one.

* `System Context` - C4 level 1
* `Container` - C4 level 2
* `Component` - C4 level 3, a layer
* `Mechanism` - a cross-cutting or delivery mechanism
* `Domain Slice`, `Entity`, `Value Object`, `Domain Event`, `Domain Errors` - the business model
* `ADR`, `Pattern`, `Convention`, `Constraint`, `Workflow`, `Technology`, `Term`, `Task`, `Template`, `Reference` - the remaining directories
