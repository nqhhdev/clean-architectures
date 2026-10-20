// Generates TS types, zod schemas and MSW handlers from openapi/emails.yaml (ADR 0008) into a git-ignored folder.
// `pnpm generate` empties the folder first. The fetch client orval emits next to the handlers is not used: the
// hand-written HTTP client in src/adapters/api/ owns fetch and error mapping (ADR 0012).
const input = './openapi/emails.yaml';
const out = './src/adapters/api/generated';

/** @type {import('orval').Config} */
export default {
  zod: {
    input,
    output: { client: 'zod', mode: 'single', target: out + '/emails.zod.ts' },
  },
  mock: {
    input,
    output: {
      client: 'fetch',
      mode: 'split',
      target: out + '/emails.ts',
      schemas: out + '/model',
      mock: { generators: [{ type: 'msw' }] },
    },
  },
};
