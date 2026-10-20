---
type: Task
title: "Server-side session enforcement"
description: "Cookie issuing and CSRF validation belong to the API or BFF and are not built here."
tags: [backlog, security]
status: draft
---
# Server-side session enforcement

**Problem.** The SPA sends `credentials: 'include'` and a CSRF header, but nothing in this repository issues the httpOnly session cookie or validates the header ([ADR 0009](../adr/0009-cookie-session-and-csrf-owned-by-the-api.md)).

**Done when** the API or BFF issues the cookie and validates the CSRF header, the header name and cookie settings are agreed and documented in `.okf/`, the placeholder sign-in is replaced, and this file is deleted and logged.
