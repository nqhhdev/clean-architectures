---
type: Reference
title: "Open Knowledge Format"
description: "The OKF v0.2 spec this bundle follows (Apache-2.0) and what this bundle adds on top."
resource: https://github.com/GoogleCloudPlatform/open-knowledge-format
tags: [reference, okf]
status: stable
---
# Open Knowledge Format

Spec: `github.com/GoogleCloudPlatform/open-knowledge-format` (`SPEC.md`, v0.2, commit `ad30107`, Apache-2.0).

**Spec essentials.** A bundle is a directory of markdown; every concept has frontmatter with a non-empty `type`; `index.md` (listing, no frontmatter except `okf_version` at the root) and `log.md` (dated entries) are reserved; trust is expressed with `generated`/`verified`, lifecycle with `status`.

**What this bundle adds (the template conventions).** A fixed layout (`architecture/`, `engineering/`, `domains/`, `adr/`, `workflows/`, `glossary/`, `backlog/`), a `type` vocabulary in the root index, an index in every directory whose entries match frontmatter, `resource:` paths that must exist, and [`tools/okf.py`](../../.okf/tools/okf.py) to check it. See [Maintain the Knowledge Base](../workflows/process/maintain-the-knowledge-base.md).
