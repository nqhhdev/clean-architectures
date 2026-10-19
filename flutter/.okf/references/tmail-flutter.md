---
type: Reference
title: "tmail-flutter"
description: "A real-world Flutter email client read for lessons; AGPL-3.0, ideas paraphrased, nothing copied."
tags: [reference, flutter, lessons]
status: stable
---
# tmail-flutter

`github.com/linagora/tmail-flutter` (local copy `~/Documents/Linagora/tmail-flutter`, branch `master`, commit `67daf7413`, read 2026-10-19).
Licensed **AGPL-3.0**. Nothing is copied; ideas are paraphrased. Do not paste its code or docs here without a deliberate licensing decision by the owner.

**What it is.** A JMAP email client: about 2,400 Dart files, 34 features under `lib/features/<feature>/{data,domain,presentation}`, 12 workspace packages, 112 ADRs. State is mostly GetX; Riverpod is being introduced alongside.

**What this starter took**
* [ADR 0004](../adr/0004-urgent-failures-single-handler.md) from its ADR 0103; [ADR 0005](../adr/0005-single-source-of-truth-for-state.md) from 0093; [ADR 0006](../adr/0006-ui-reads-from-repository-cache.md) from 0017
* [Logging](../engineering/conventions/logging.md) from 0069; Riverpod 3 pitfalls (0092) in [ADR 0003](../adr/0003-riverpod-for-di-and-state.md)
* The robot idea for e2e ([Test Robot](../engineering/patterns/test-robot.md)); Patrol is its e2e tool ([ADR 0007](../adr/0007-test-pyramid-and-device-e2e.md)).

**Where this starter differs.** Layers by role per the official guide instead of a data/domain/presentation triple per feature; Riverpod only (no GetX); no Hive cache, no JMAP, no sub-packages. Dart pub workspaces (its ADR 0090) are the option when this stack must split into packages.

**Partial reading.** Roughly 8 to 10 of its 112 ADRs were read. Push notifications, web specifics, Sentry, Patrol setup and Cozy/Workplace integrations were not.
