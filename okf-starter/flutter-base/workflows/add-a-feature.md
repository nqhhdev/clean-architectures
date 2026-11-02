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
2. Domain: models `<and use case>`, with unit tests.
3. Data: service / API client, DTOs and mapper, repository, with unit tests using fakes or mocks.
4. Wire it in the composition root `<config / di / providers>`.
5. UI: state holder, then screen and widgets, with widget tests (and goldens if the repo uses them).
6. Navigation entry and localized strings.
7. Run [Build](build.md) and [Test](test.md); re-read [Constraints](../engineering/constraints.md).
8. Update `.okf/` in the same change ([Maintain the Knowledge Base](maintain-the-knowledge-base.md)).
