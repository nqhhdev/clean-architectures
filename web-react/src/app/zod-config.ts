import { z } from 'zod';

// zod 4 probes `new Function` when it builds an object schema, to compile a fast parser. The CSP has no
// `unsafe-eval` (ADR 0019), so the probe is reported as a `script-src` violation. Entry files import this module first,
// before any module that defines a schema, so every schema is built jitless.
z.config({ jitless: true });
