---
type: Technology
title: "json_serializable"
description: "Generates checked fromJson/toJson for DTOs in data/services/model."
resource: build.yaml
tags: [technology, codegen, json]
status: stable
---
# json_serializable

**Version:** `json_annotation ^4.9.0`, `json_serializable ^6.11.2` (dev). **Wrapped by:** `data/services` - only DTOs carry JSON.
**Notes:** [`build.yaml`](../../../build.yaml) sets `checked: true` and `explicit_to_json: true`; the service turns
`CheckedFromJsonException` into `ApiFailure.malformed`. Output `*.g.dart` is git-ignored. Decision: [ADR 0011](../../adr/0011-code-generation-freezed-json.md).
