---
type: Workflow
title: "Extending the Template"
description: "How to turn this starter into a real product and grow the knowledge base with it."
tags: [workflow, template, adoption]
status: stable
---
# Extending the Template

1. Copy this folder into the real repository (including the `.okf/` and `env/` folders).
2. Rename by hand: the package name in `pubspec.yaml` and every `package:clean_architecture/` import; the Android `namespace`, `applicationId` and the `MainActivity.kt` package path; the iOS bundle ids and display names per flavor; the app title and banner strings in the ARB files; the `pubspec.yaml` description and version `0.1.0+1`; real URLs in `env/*.json`. Then remove the Emails example.
3. Scan the real project, then update this bundle: replace the `draft` pages, the Emails domain, the context and containers.
4. Keep the layout; fill what exists, leave the rest `draft`. Write an [ADR](../../adr/index.md) for any deviation from the layers.

