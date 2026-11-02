---
type: Workflow
title: "Build"
description: "Get dependencies, generate code, analyze, format and build release artifacts."
tags: [workflow, build]
status: draft
---
# Build

Replace each command with the one the repo uses (Makefile, melos, fvm, scripts).

```sh
flutter pub get
dart run build_runner build -d          # only if the repo uses code generation
flutter analyze
dart format --set-exit-if-changed .
flutter build apk --flavor <flavor>     # or appbundle / ipa / web
```

**Verify:** all commands exit 0. Release signing and store upload: `<link the delivery page or ADR>`.
