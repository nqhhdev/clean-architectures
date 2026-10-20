// Bundle check (K24, S5). Without flags it proves a production `dist/` holds no mock-mode code and no source maps.
// With `--expect-mock` it proves the same markers ARE in a mock build, so the check cannot pass by scanning nothing.
import { readdirSync, readFileSync } from 'node:fs';
import { join, relative } from 'node:path';
import { pathToFileURL } from 'node:url';

const MOCK_FILE = /mockServiceWorker|\.mock\./i;
const MOCK_CODE = [/mockServiceWorker/, /msw\/browser/, /setupWorker/, /main\.mock/];
const MAP_REF = /\/\/[#@] sourceMappingURL=/;

/** @param {string} dir @returns {string[]} */
function files(dir) {
  return readdirSync(dir, { withFileTypes: true, recursive: true })
    .filter((entry) => entry.isFile())
    .map((entry) => join(entry.parentPath, entry.name));
}

/** Problems that make `dir` unfit to ship: mock code, MSW worker, source maps. @param {string} dir */
export function productionProblems(dir) {
  const problems = [];
  for (const file of files(dir)) {
    const name = relative(dir, file);
    if (name.endsWith('.map')) problems.push(`${name}: source map`);
    if (MOCK_FILE.test(name)) problems.push(`${name}: mock-mode file`);
    if (/\.(js|mjs|html|css)$/.test(name)) {
      const text = readFileSync(file, 'utf8');
      for (const pattern of MOCK_CODE) {
        if (pattern.test(text)) problems.push(`${name}: contains ${String(pattern)}`);
      }
      if (MAP_REF.test(text)) problems.push(`${name}: sourceMappingURL comment`);
    }
  }
  return problems;
}

/** Markers a mock build must contain. @param {string} dir */
export function mockMarkersMissing(dir) {
  const all = files(dir);
  const worker = all.some((file) => relative(dir, file) === 'mockServiceWorker.js');
  const code = all
    .filter((file) => file.endsWith('.js'))
    .some((file) => /setupWorker/.test(readFileSync(file, 'utf8')));
  return [
    ...(worker ? [] : ['mockServiceWorker.js is missing']),
    ...(code ? [] : ['no MSW code (setupWorker) in any script']),
  ];
}

/** @param {string[]} argv */
function main(argv) {
  const expectMock = argv.includes('--expect-mock');
  const dir = argv.find((arg) => !arg.startsWith('--')) ?? (expectMock ? 'dist-mock' : 'dist');
  const problems = expectMock ? mockMarkersMissing(dir) : productionProblems(dir);
  if (problems.length > 0) {
    console.error(`bundle check failed for ${dir}:\n- ${problems.join('\n- ')}`);
    process.exit(1);
  }
  console.log(
    `bundle check ok: ${dir} (${expectMock ? 'mock markers present' : 'production clean'})`,
  );
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? '').href) main(process.argv.slice(2));
