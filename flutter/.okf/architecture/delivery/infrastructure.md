---
type: Mechanism
title: "Infrastructure"
description: "Build signing, release channels and deployment of the app; flavors exist, signing and release do not."
tags: [release, infrastructure]
status: draft
---
# Infrastructure

> **Draft.** Flavors and bundle ids per environment exist ([Configuration and Environments](../cross-cutting/configuration.md));
> bundle ids are still `dev.example.cleanArchitecture[.dev|.stg]`.

Unverified: release signing (Android `buildTypes.release` still has a TODO in [`build.gradle.kts`](../../../android/app/build.gradle.kts)),
store release and any IaC are not set up. Record them here when added.
