import { defineConfig, devices } from '@playwright/test';

// Smoke test against the built mock-mode bundle served by `vite preview`, not the dev server (ADR 0017).
const port = 4173;
const origin = `http://localhost:${String(port)}`;

export default defineConfig({
  testDir: './e2e',
  forbidOnly: Boolean(process.env.CI),
  retries: process.env.CI ? 1 : 0,
  reporter: process.env.CI ? 'github' : 'list',
  use: { baseURL: origin, trace: 'retain-on-failure' },
  projects: [{ name: 'chromium', use: { ...devices['Desktop Chrome'] } }],
  webServer: {
    command: `pnpm exec vite preview --mode mock --port ${String(port)} --strictPort`,
    url: origin,
    reuseExistingServer: !process.env.CI,
  },
});
