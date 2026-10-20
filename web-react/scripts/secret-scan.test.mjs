// @vitest-environment node
import { mkdtempSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

import { describe, expect, it } from 'vitest';

import { scanFiles, scanText } from './secret-scan.mjs';

describe('scanText', () => {
  it.each([
    ['private key block', '-----BEGIN RSA PRIVATE KEY-----'],
    ['AWS access key id', 'key = AKIAABCDEFGHIJKLMNOP'],
    ['GitHub token', `token ghp_${'a'.repeat(36)}`],
    ['JSON web token', 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.abcdefghijk'],
    ['bearer credential literal', 'Authorization: Bearer abcdefghijklmnopqrstuvwxyz012345'],
    ['hard-coded secret assignment', 'const password = "correct-horse-battery"'],
    ['secret-looking VITE_ variable', 'VITE_API_TOKEN=abc'],
  ])('flags a %s', (name, text) => {
    expect(scanText(text)).toContain(name);
  });

  it('accepts ordinary code and public config', () => {
    expect(scanText('const baseUrl = "/api"; VITE_API_URL=https://api.example.com')).toEqual([]);
    expect(scanText("headers['X-XSRF-TOKEN'] = value")).toEqual([]);
  });
});

describe('scanFiles', () => {
  it('reports the path and rule, and skips lockfiles', () => {
    const dir = mkdtempSync(join(tmpdir(), 'secret-scan-'));
    const leaky = join(dir, 'leaky.ts');
    const lock = join(dir, 'pnpm-lock.yaml');
    writeFileSync(leaky, 'const apiKey = "abcdefghijklmnop";');
    writeFileSync(lock, 'const apiKey = "abcdefghijklmnop";');

    expect(scanFiles([leaky, lock])).toEqual([`${leaky}: hard-coded secret assignment`]);
  });
});
