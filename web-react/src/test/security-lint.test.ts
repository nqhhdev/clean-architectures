// @vitest-environment node
import { resolve } from 'node:path';

import { ESLint } from 'eslint';

// Rule self-test (ADR 0019): each snippet is lint-checked as production code using only the security config.
const root = resolve(import.meta.dirname, '../..');
const eslint = new ESLint({ cwd: root, overrideConfigFile: 'eslint.security.config.js' });

async function messages(source: string, path = 'src/adapters/auth/fixture.ts') {
  const [result] = await eslint.lintText(source, { filePath: resolve(root, path) });
  const all = result?.messages ?? [];
  expect(all.filter((m) => m.fatal)).toEqual([]);
  return all.filter((m) => m.ruleId === 'no-restricted-syntax');
}

describe('security lint rules', () => {
  it.each([
    ['localStorage read', "export const t = localStorage.getItem('token');"],
    ['sessionStorage write', "sessionStorage.setItem('token', 'x');"],
    ['window.localStorage', 'export const s = window.localStorage;'],
    ['globalThis bracket access', "export const s = globalThis['sessionStorage'];"],
    ['cookie write', "document.cookie = 'token=x';"],
    [
      'dangerouslySetInnerHTML prop',
      'export const a = <div dangerouslySetInnerHTML={{ __html: h }} />;',
    ],
    [
      'dangerouslySetInnerHTML via createElement props',
      'export const p = { dangerouslySetInnerHTML: { __html: h } };',
    ],
  ])('flags %s', async (_name, source) => {
    const path = source.includes('<div') ? 'src/features/home/x.tsx' : undefined;

    expect((await messages(source, path)).length).toBeGreaterThan(0);
  });

  it('allows reading document.cookie (the CSRF hook) and ordinary code', async () => {
    expect(await messages('export const c = document.cookie.split(";");')).toEqual([]);
    expect(await messages('export const n = 1;')).toEqual([]);
  });
});
