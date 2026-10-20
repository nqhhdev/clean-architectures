Known gaps and planned work. Each file is a `Task` with `status: draft`; delete it when done and log it.

# Concepts
* [Restore jsx-a11y lint when it supports ESLint 10](jsx-a11y-eslint-10.md) - eslint-plugin-jsx-a11y is dropped because its peer range stops at ESLint 9; add it back (strict) when a release supports ESLint 10.
* [Realtime live port](realtime-live-port.md) - Optional SSE-over-fetch live port in application/ with an adapter in adapters/live/, built only when a feature needs server push.
* [Server-side session enforcement](server-side-session-enforcement.md) - Cookie issuing and CSRF validation belong to the API or BFF and are not built here.
* [TypeScript 7 upgrade](typescript-7-upgrade.md) - TypeScript is pinned to 6.0.3 because typescript-eslint does not support 7 yet.
