---
type: Convention
title: "Naming and Placement"
description: "Where each kind of file lives and what it is called - one table, one row per kind."
tags: [convention, naming]
status: draft
---
# Naming and Placement

Fill the table from the real repo; one row per kind of file. **Choose** one file-name case (`kebab-case`, `PascalCase` for components, ...) and enforce it with a lint rule.

| Kind | Folder | File | Export |
|---|---|---|---|
| Route / page | `<src/app/ or src/routes/>` | `<x.tsx / x.route.tsx>` | `<XPage>` |
| Component | `<src/features/<feature>/>` | `<XView.tsx / x-view.tsx>` | `<XView>` |
| Hook | `<...>` | `<use-x.ts>` | `<useX>` |
| Port / use case | `<src/application/>` | `<x-port.ts>` | `<XPort>` |
| Adapter | `<src/adapters/>` | `<x-http.ts>` | `<createXHttp>` |
| Test | next to the file or `test/` | `<x.test.ts(x)>` | |

Imports: **choose** a path alias (`@/`) or relative imports, and enforce it.
