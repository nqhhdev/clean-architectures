---
okf_version: "0.2"
---

The knowledge base for this React web repo, as an [Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format) v0.2 bundle: one concept per file, at a stable path. Open the `index.md` of the directory that matches your question and follow only the links you need. If you learn something durable about the codebase, write it here (see [Maintain the Knowledge Base](workflows/maintain-the-knowledge-base.md)), not into a comment.

Every page starts as `status: draft` with placeholders in `<angle brackets>`; fill it from the real code, then mark it `stable`.

# Start here

* [Understand the system](architecture/context.md) - C4 level 1 - fill in first.
* [See the layers](architecture/components/index.md) - C4 level 3 - what each layer may import.
* [Know the rules](engineering/constraints.md) - Every rule, what enforces it, and the page that owns it.
* [Name and place a file](engineering/conventions/naming.md) - Where each kind of file lives and what it is called.
* [Add a feature](workflows/add-a-feature.md) - The skeleton procedure across every layer.
* [Know why it is like this](adr/index.md) - Architecture Decision Records.
* [Something is wrong](troubleshooting.md) - Symptoms mapped to causes.

# Subdirectories

* [adr](adr/) - Architecture Decision Records - why the codebase is the way it is.
* [architecture](architecture/) - C4 levels 1-3: context, containers and components. Level 4 is the code.
* [backlog](backlog/) - Known gaps and planned work.
* [domains](domains/) - The business model - one folder per domain slice.
* [engineering](engineering/) - Constraints, conventions and patterns.
* [glossary](glossary/) - One file per term, grouped by subject.
* [references](references/) - External material this bundle draws on.
* [workflows](workflows/) - Step-by-step procedures and exact commands.

# Concepts

* [Bundle Map](map.md) - Generated - every file in this bundle with its type, description and tags, for one-read search.
* [Starter README](README.md) - How to copy this starter into a repo as .okf/ and fill it in.
* [Troubleshooting by Symptom](troubleshooting.md) - Common failure symptoms, each mapped to its likely cause and the page that explains it.

# Concept types

Every concept declares exactly one of these in `type:`; the checker (`python3 .okf/tools/okf.py`) rejects anything else. Add a new value here before using it, and never a near-synonym of an existing one.

* `System Context` - C4 level 1
* `Container` - C4 level 2
* `Component` - C4 level 3, a layer
* `Mechanism` - a cross-cutting or delivery mechanism
* `Domain Slice`, `Entity`, `Value Object`, `Domain Event`, `Domain Errors` - the business model
* `ADR`, `Pattern`, `Convention`, `Constraint`, `Workflow`, `Technology`, `Term`, `Task`, `Template`, `Reference` - the remaining directories
