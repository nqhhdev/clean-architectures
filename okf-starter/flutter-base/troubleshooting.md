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
| `Target of URI hasn't been generated` (`*.g.dart`, `*.freezed.dart`) | Code generation has not run | [Build](workflows/build.md) |
| Golden test fails on a Mac but passes on CI | Goldens are OS-dependent; Linux/CI is canonical | [Test](workflows/test.md) |
| App starts against the wrong backend | Wrong flavor or missing env file | [Run Flavors](workflows/run-flavors.md) |
| `okf.py` reports an index problem | A new file is not listed, or a description drifted | [Maintain the Knowledge Base](workflows/maintain-the-knowledge-base.md) |
| `<symptom>` | `<cause>` | `<page>` |
