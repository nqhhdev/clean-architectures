---
type: Workflow
title: "Format Code"
description: "Format Dart sources with dart format and check without changing files."
tags: [workflow, format]
status: stable
---
# Format Code

```bash
dart format lib test tool integration_test                                   # rewrite
dart format --output=none --set-exit-if-changed lib test tool integration_test   # check only
```
Only reformat files you created or modified in a change.
