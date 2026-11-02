# OKF starters

Generic, repo-agnostic starter knowledge bases in [Open Knowledge Format](https://github.com/GoogleCloudPlatform/open-knowledge-format) v0.2.

| Folder | Stack |
|---|---|
| [flutter-base](flutter-base/) | Flutter / Dart app |
| [web-react-base](web-react-base/) | React web app (TypeScript) |

## Use one
1. Copy the folder to your repo as `.okf`: `cp -R okf-starter/flutter-base <your-repo>/.okf` (or `web-react-base`).
2. Follow its `README.md`: fill the draft pages from the real code, mirror your ADRs, choose your patterns.
3. From the repo root run `python3 .okf/tools/okf.py --check` (Python 3, standard library only); add it to CI or a pre-commit hook.
4. Point every coding agent at `.okf/index.md`.

Every page starts as `status: draft`. No library or tool is mandated; choices are recorded as ADRs in your repo.
