---
type: Reference
title: "Troubleshooting by Symptom"
description: "Common failure symptoms, each mapped to its likely cause and the page that explains it."
tags: [troubleshooting]
status: draft
---
# Troubleshooting by Symptom

| Symptom | Likely cause | Read |
|---|---|---|
| `Cannot find module` for generated API types | Code generation has not run | [Build](workflows/build.md) |
| Visual snapshot fails locally but passes on CI | Snapshots are OS-dependent; Linux/CI is canonical | [Test](workflows/test.md) |
| App calls the wrong backend | Wrong mode or env file | [Run the App](workflows/run-the-app.md) |
| Lint error about an import between layers | An import points the wrong way | [Components](architecture/components/index.md) |
| `okf.py` reports an index problem | A new file is not listed, or a description drifted | [Maintain the Knowledge Base](workflows/maintain-the-knowledge-base.md) |
| `<symptom>` | `<cause>` | `<page>` |
