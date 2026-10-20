import { defineConfig, mergeConfig } from 'vitest/config';

import viteConfig from './vite.config.js';

export default defineConfig((env) =>
  mergeConfig(
    viteConfig(env),
    defineConfig({
      test: {
        environment: 'jsdom',
        globals: true,
        setupFiles: ['./src/test/setup.ts'],
        // `e2e/` belongs to Playwright; `scripts/` and `docker/` tests cover the check scripts and the entrypoint.
        include: ['src/**/*.test.{ts,tsx}', 'scripts/**/*.test.mjs', 'docker/**/*.test.mjs'],
        coverage: {
          provider: 'v8',
          include: ['src/**'],
          exclude: [
            'src/main.tsx',
            'src/main.mock.tsx',
            'src/adapters/api/generated/**',
            'src/test/**',
            'src/locales/**',
            'src/**/*.test.{ts,tsx}',
          ],
          thresholds: { lines: 80 },
        },
      },
    }),
  ),
);
