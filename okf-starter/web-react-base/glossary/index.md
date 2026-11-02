One file per term. Each section groups terms by subject (the first tag).

# architecture
* [Layer](layer.md) - A group of code with one role and a fixed list of layers it may import.
* [Port](port.md) - An interface the application layer owns and an adapter implements, so the UI never depends on I/O.
* [Adapter](adapter.md) - Code that implements a port with real I/O: HTTP, storage, logging.
* [Composition Root](composition-root.md) - The one place that picks concrete adapters and wires them into the app.

# configuration
* [Environment Mode](environment-mode.md) - One way of running or building the app (dev, mock, prod) with its own config and backend.
