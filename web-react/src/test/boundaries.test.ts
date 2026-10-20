// @vitest-environment node
import { readdirSync, readFileSync } from 'node:fs';
import { join, resolve } from 'node:path';

import { ESLint } from 'eslint';

// Rule self-test (ADR 0010): every fixture is lint-checked as if it lived at its `// path:` header,
// using only the boundary config. Fixtures use the `.fixture` extension so `pnpm lint` ignores them.
const root = resolve(import.meta.dirname, '../..');
const fixtureDir = join(import.meta.dirname, 'boundary-fixtures');
const eslint = new ESLint({ cwd: root, overrideConfigFile: 'eslint.boundaries.config.js' });

function header(source: string, key: 'path' | 'expect'): string {
  const match = new RegExp(`^// ${key}: (.+)$`, 'm').exec(source);
  if (!match?.[1]) throw new Error(`fixture is missing "// ${key}:" header`);
  return match[1];
}

const fixtures = readdirSync(fixtureDir)
  .filter((name) => name.endsWith('.fixture'))
  .map((name) => {
    const source = readFileSync(join(fixtureDir, name), 'utf8');
    return {
      name,
      source,
      path: header(source, 'path'),
      expect: header(source, 'expect') as 'violation' | 'ok',
    };
  });

describe('boundary rules', () => {
  it('has both violating and valid fixtures', () => {
    expect(fixtures.filter((f) => f.expect === 'violation').length).toBeGreaterThan(0);
    expect(fixtures.filter((f) => f.expect === 'ok').length).toBeGreaterThan(0);
  });

  async function lint(source: string, path: string) {
    const [result] = await eslint.lintText(source, { filePath: resolve(root, path) });
    const messages = result?.messages ?? [];
    expect(messages.filter((m) => m.fatal)).toEqual([]);
    return messages;
  }

  it.each(fixtures.filter((f) => f.expect === 'violation'))(
    '$name -> violation',
    async ({ source, path }) => {
      const messages = await lint(source, path);

      expect(
        messages.filter((m) => m.ruleId === 'boundaries/dependencies' && m.severity === 2).length,
      ).toBeGreaterThan(0);
    },
  );

  it.each(fixtures.filter((f) => f.expect === 'ok'))('$name -> ok', async ({ source, path }) => {
    expect(await lint(source, path)).toEqual([]);
  });
});
