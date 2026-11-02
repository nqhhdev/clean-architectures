C4 level 3 - the layers inside the app and what each may import. Level 4 is the code itself: link real files from each layer page.

Rename, add or remove layers to match the repo (for example a composition root such as `config/` or `di/`, or a shared `utils/`).
Verify the directions with the imports, not the folder names.

```
UI  ->  Domain  <-  Data
```

# Concepts
* [UI Layer](ui.md) - C4 level 3 - screens, widgets and the state holders that drive them.
* [Domain Layer](domain.md) - C4 level 3 - business models and optional use cases, free of Flutter and I/O.
* [Data Layer](data.md) - C4 level 3 - repositories and the services, DTOs and storage they wrap.
