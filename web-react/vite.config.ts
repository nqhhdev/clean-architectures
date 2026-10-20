import { fileURLToPath } from 'node:url';

import react from '@vitejs/plugin-react';
import { defineConfig, type Plugin } from 'vite';

// Mock mode (ADR 0017): the same `index.html` with its module entry swapped to `main.mock.tsx`, so the production HTML
// never names it. The `/env.js` script is dropped too: mock mode has no runtime config, MSW answers the API. Only mock
// mode serves `public-mock/` (the MSW worker script) and it builds into `dist-mock/`, which keeps `dist/` free of MSW
// (K24).
const mockEntry = (): Plugin => ({
  name: 'mock-entry',
  // `pre`: the build collects the module entry from the HTML before the default-order hooks run.
  transformIndexHtml: {
    order: 'pre',
    handler: (html) =>
      html
        .replace('/src/main.tsx', '/src/main.mock.tsx')
        .replace(/\s*<script src="\/env\.js"><\/script>/, ''),
  },
});

export default defineConfig(({ mode }) => {
  const mock = mode === 'mock';
  return {
    plugins: [react(), ...(mock ? [mockEntry()] : [])],
    resolve: {
      alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) },
    },
    ...(mock ? { publicDir: 'public-mock' } : {}),
    build: {
      outDir: mock ? 'dist-mock' : 'dist',
      // No source maps in what ships (S5).
      sourcemap: false,
    },
  };
});
