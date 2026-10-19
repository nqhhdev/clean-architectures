---
type: Task
title: "Real authentication flow"
description: "A 401 redirects to a placeholder sign-in screen; there is no real sign-in, token storage or refresh."
tags: [backlog]
status: draft
---
# Real authentication flow

**Problem.** Replace `SignInViewModel.signIn` and `authTokenSourceProvider` with a real sign-in, secure token storage and refresh
([ADR 0017](../adr/0017-routing-go-router.md), [Security and Authorization](../architecture/cross-cutting/security-and-authorization.md)).

**Done when** it is built, documented in `.okf/`, and this file is deleted and logged.
