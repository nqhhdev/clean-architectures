---
type: Template
title: "Entity Template"
description: "Copy this when adding a domain model."
tags: [template, domain]
status: stable
---
# Entity Template

> Copy to `.okf/domains/<slice>/<entity>.md`. Delete this quote block.

```yaml
---
type: Entity
title: "Entity"
description: "One sentence."
resource: lib/domain/models/<entity>.dart
tags: [entity]
status: stable
---
```
Sections: **Fields** (only what the code does not say), **Invariants**, **Errors** (link the errors page). Link the `.dart`; do not restate it.
