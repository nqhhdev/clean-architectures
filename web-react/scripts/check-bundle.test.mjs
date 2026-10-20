// @vitest-environment node
import { mkdirSync, mkdtempSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

import { describe, expect, it } from 'vitest';

import { mockMarkersMissing, productionProblems } from './check-bundle.mjs';

function bundle(entries) {
  const dir = mkdtempSync(join(tmpdir(), 'check-bundle-'));
  for (const [name, content] of Object.entries(entries)) {
    const path = join(dir, name);
    mkdirSync(join(path, '..'), { recursive: true });
    writeFileSync(path, content);
  }
  return dir;
}

describe('productionProblems', () => {
  it('passes a clean bundle', () => {
    const dir = bundle({
      'index.html': '<script src="/assets/a.js"></script>',
      'assets/a.js': 'console.log(1)',
    });

    expect(productionProblems(dir)).toEqual([]);
  });

  it('flags the MSW worker, mock code and source maps', () => {
    const dir = bundle({
      'mockServiceWorker.js': '//',
      'assets/a.js': 'setupWorker();\n//# sourceMappingURL=a.js.map',
      'assets/a.js.map': '{}',
    });

    expect(productionProblems(dir)).toEqual(
      expect.arrayContaining([
        'mockServiceWorker.js: mock-mode file',
        'assets/a.js: contains /setupWorker/',
        'assets/a.js: sourceMappingURL comment',
        'assets/a.js.map: source map',
      ]),
    );
  });
});

describe('mockMarkersMissing', () => {
  it('is empty for a mock build and names what a production build lacks', () => {
    const mock = bundle({ 'mockServiceWorker.js': '//', 'assets/a.js': 'setupWorker()' });
    const prod = bundle({ 'assets/a.js': 'console.log(1)' });

    expect(mockMarkersMissing(mock)).toEqual([]);
    expect(mockMarkersMissing(prod)).toHaveLength(2);
  });
});
