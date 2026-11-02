---
type: Workflow
title: "Add a Feature"
description: "The skeleton procedure for adding a feature across every layer, outside in or inside out."
tags: [workflow, feature]
status: draft
---
# Add a Feature

Adapt the steps to the layers in [Components](../architecture/components/index.md) and the patterns the repo chose.

1. Describe the slice in [domains/](../domains/index.md) (entities, errors) if it is new business.
2. Domain: types and pure rules, with unit tests.
3. Application: the port and use case the UI will call.
4. Adapters: API client call, boundary validation, mapper; tests with mocked HTTP.
5. Wire it in the composition root `<main.tsx / providers>`.
6. UI: route, components, data hook; component tests; strings in the locale files.
7. An end-to-end test for the main path if the repo has them.
8. Run [Build](build.md) and [Test](test.md); re-read [Constraints](../engineering/constraints.md).
9. Update `.okf/` in the same change ([Maintain the Knowledge Base](maintain-the-knowledge-base.md)).
