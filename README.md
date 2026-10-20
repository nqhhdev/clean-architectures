# clean-architecture

A monorepo of clean-architecture starters, one folder per tech stack. Each stack is self-contained: its own
source, its own tests that enforce the layer rules, and its own `.okf/` knowledge bundle (ADRs, workflows,
constraints). Stacks do not depend on each other and share no code.

| Folder | Stack | Status |
|---|---|---|
| [`flutter/`](flutter/) | Flutter / Dart (iOS + Android) | v1 - official-guide layers + Riverpod + `Emails` example slice with unit, widget, integration and device e2e tests + OKF bundle |
| [`web-react/`](web-react/) | React + TypeScript (Vite) | v1 - hexagonal layers enforced by lint, generated API client, `Emails` example slice with unit, component, MSW and Playwright tests + OKF bundle |

Later, on request: iOS SwiftUI, Android Kotlin, React Native, Java backend.

Business logic is intentionally absent. Each stack ships one small example slice (`Emails` in Flutter) so the
architecture tests have real code to check; delete it when you start your own domain.

Design reference: [`quannv108/clean-architecture-template`](https://github.com/quannv108/clean-architecture-template)
(.NET). Ideas and structure are adapted, nothing is copied; it has no license file.

## How to use

Each stack is a self-contained folder. See its README for commands.

| You have | Do |
|---|---|
| A new app | Copy `<stack>/` into your repository and follow the stack's "Extending the Template" page in its `.okf/` |
| An existing app | Copy the stack's `.okf/` and adopt the layers feature by feature |

| Stack | Check command | Details |
|---|---|---|
| Flutter | see [`flutter/README.md`](flutter/README.md) (format, analyze, test, `.okf` check) | [`flutter/README.md`](flutter/README.md) |
| React web | `pnpm check` in `web-react/` (generate, format, lint, typecheck, coverage, build, bundle and secret scans, `.okf` check); `pnpm e2e` for the browser smoke test | [`web-react/README.md`](web-react/README.md) |

Commits: one logical part per commit, one short Conventional-Commits line.
