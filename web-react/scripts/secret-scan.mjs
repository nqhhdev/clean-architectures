// Secret scan (S1): `VITE_*` values and `env.js` are public, so nothing secret may be committed or end up in `dist/`.
// Scans files git knows about (tracked plus untracked and not ignored) and, when present, the built `dist/`.
import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';

const RULES = [
  { name: 'private key block', pattern: /-----BEGIN (?:[A-Z]+ )?PRIVATE KEY-----/ },
  { name: 'AWS access key id', pattern: /\b(?:AKIA|ASIA)[0-9A-Z]{16}\b/ },
  { name: 'GitHub token', pattern: /\bgh[pousr]_[A-Za-z0-9]{36,}\b/ },
  { name: 'Slack token', pattern: /\bxox[baprs]-[A-Za-z0-9-]{10,}/ },
  {
    name: 'JSON web token',
    pattern: /\beyJ[A-Za-z0-9_-]{8,}\.eyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}/,
  },
  { name: 'bearer credential literal', pattern: /\bBearer\s+[A-Za-z0-9._~+/-]{20,}=*/ },
  {
    name: 'hard-coded secret assignment',
    pattern:
      /\b(?:secret|password|passwd|api[_-]?key|access[_-]?token|auth[_-]?token)\w*["']?\s*[:=]\s*["'][^"'\s]{12,}["']/i,
  },
  // Anything `VITE_`-prefixed is inlined into the bundle, so a name that promises secrecy is a mistake.
  {
    name: 'secret-looking VITE_ variable',
    pattern: /\bVITE_\w*(?:SECRET|TOKEN|PASSWORD|PRIVATE|API_?KEY)\w*/i,
  },
];

// Not authored here, or integrity hashes that look like keys.
const SKIP = [
  /(^|\/)pnpm-lock\.yaml$/,
  /(^|\/)public-mock\//,
  /(^|\/)src\/adapters\/api\/generated\//,
];
// The scanner and its test hold the patterns and sample secrets on purpose.
const SELF = [/^scripts\/secret-scan(\.test)?\.mjs$/];
const BINARY = /\.(png|jpe?g|gif|ico|woff2?|ttf|webp)$/i;

/** @param {string} text @returns {string[]} names of the rules the text breaks */
export function scanText(text) {
  return RULES.filter(({ pattern }) => pattern.test(text)).map(({ name }) => name);
}

/** @param {string} dir @returns {string[]} */
function listDir(dir) {
  return readdirSync(dir, { withFileTypes: true, recursive: true })
    .filter((entry) => entry.isFile())
    .map((entry) => join(entry.parentPath, entry.name));
}

/** @returns {string[]} */
function sourceFiles() {
  const out = execFileSync(
    'git',
    ['ls-files', '--cached', '--others', '--exclude-standard', '-z'],
    {
      encoding: 'utf8',
    },
  );
  return out.split('\0').filter((file) => file !== '' && existsSync(file));
}

/** @param {string[]} paths @returns {string[]} findings as `path: rule` */
export function scanFiles(paths) {
  const findings = [];
  for (const path of paths) {
    if (BINARY.test(path) || SKIP.some((re) => re.test(path)) || SELF.some((re) => re.test(path)))
      continue;
    for (const rule of scanText(readFileSync(path, 'utf8'))) findings.push(`${path}: ${rule}`);
  }
  return findings;
}

function main() {
  const paths = [...sourceFiles(), ...(existsSync('dist') ? listDir('dist') : [])];
  const findings = scanFiles(paths);
  if (findings.length > 0) {
    console.error(`secret scan failed:\n- ${findings.join('\n- ')}`);
    process.exit(1);
  }
  console.log(`secret scan ok: ${String(paths.length)} files`);
}

if (import.meta.url === pathToFileURL(process.argv[1] ?? '').href) main();
