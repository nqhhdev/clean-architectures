# Understanding gate — architecture (2026-10-19)

1. Why can't `application/` import React?
   Core business rules must run and be tested without React (plain Vitest, no render), survive a UI/fetch swap, and stay reusable. Lint (boundaries) only enforces it; it isn't the reason.

2. What breaks if an adapter throws instead of returning `Err`?
   The port promises `Result`; callers only handle `Err`, so the throw escapes (crash/blank screen). The error is `unknown`, not `AppError`, so no `kind` -> i18n mapping, and the no-retry-on-4xx rule can't read `status`. `Result` turns errors into typed data.

3. Feature A wants feature B's date formatter?
   Not allowed (K30, no cross-feature imports). Move pure logic down to `domain/` (e.g. `domain/date/formatDate.ts`), UI pieces to `ds/`; both features import from there. Shared code goes down a layer, never sideways.
