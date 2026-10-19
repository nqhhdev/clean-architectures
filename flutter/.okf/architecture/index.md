C4 levels 1-3 (context, containers, components), cross-cutting mechanisms and delivery.

# Subdirectories
* [components](components/) - C4 level 3 - the layers of lib/ and what each may import.
* [containers](containers/) - C4 level 2 - what runs where: the app, the mock API and the real backend.
* [cross-cutting](cross-cutting/) - Mechanisms that cut across layers: layering, slices, request flow, errors, caching, state, navigation, l10n, theming, config, API, security.
* [delivery](delivery/) - How the stack is built, tested, released and developed locally.

# Concepts
* [System Context](context.md) - C4 level 1 - what this app is, who uses it, and which external systems it depends on.
* [Solution Layout](solution-layout.md) - The directories and root files that make up the Flutter stack.
