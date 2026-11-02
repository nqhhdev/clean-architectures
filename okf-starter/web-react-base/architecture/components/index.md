C4 level 3 - the layers inside the web app and what each may import. Level 4 is the code itself: link real files from each layer page.

Rename, add or remove layers to match the repo (for example a composition root in `main.tsx`, a design system, locales).
Many apps have only UI plus a data folder; document what exists and verify directions with the imports, not the folder names.

```
UI  ->  Application  ->  Domain
             ^
          Adapters
```

# Concepts
* [UI Layer](ui.md) - C4 level 3 - routes, pages, feature components and the design system.
* [Application Layer](application.md) - C4 level 3 - use cases and the ports (interfaces) the UI calls and adapters implement.
* [Domain Layer](domain.md) - C4 level 3 - business types and pure functions, free of React and I/O.
* [Adapters Layer](adapters.md) - C4 level 3 - HTTP clients, API mappers, storage and other I/O behind the ports.
