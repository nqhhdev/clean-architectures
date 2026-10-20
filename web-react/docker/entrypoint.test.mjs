// @vitest-environment node
import { spawnSync } from 'node:child_process';
import { existsSync, mkdtempSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

import { describe, expect, it } from 'vitest';

import { parseRuntimeConfig } from '../src/app/runtime-config';

const script = fileURLToPath(new URL('./entrypoint.sh', import.meta.url));

/** Runs the entrypoint into a temp dir; returns exit status, stderr and the generated files. */
function run(env, args = []) {
  const dir = mkdtempSync(join(tmpdir(), 'entrypoint-'));
  const paths = {
    RUNTIME_DIR: join(dir, 'runtime'),
    NGINX_CONF_PATH: join(dir, 'default.conf'),
    WEB_ROOT: '/srv/www',
  };
  const result = spawnSync('sh', [script, ...args], {
    env: { PATH: process.env.PATH, ...paths, ...env },
    encoding: 'utf8',
  });
  const read = (path) => (existsSync(path) ? readFileSync(path, 'utf8') : undefined);
  return {
    status: result.status,
    stdout: result.stdout,
    stderr: result.stderr,
    envJs: read(join(paths.RUNTIME_DIR, 'env.js')),
    headers: read(join(paths.RUNTIME_DIR, 'security-headers.conf')),
    conf: read(paths.NGINX_CONF_PATH),
  };
}

const csp = (headers) => /add_header Content-Security-Policy "([^"]*)"/.exec(headers)?.[1];
const directive = (policy, name) => policy.split('; ').find((part) => part.startsWith(`${name} `));

describe('entrypoint env.js', () => {
  it('writes API_URL as the runtime config the SPA parses', () => {
    const out = run({ API_URL: 'https://api.example.com/v1/' });

    expect(out.status).toBe(0);
    expect(out.envJs).toBe(
      'window.__ENV__ = Object.freeze({"API_URL":"https://api.example.com/v1"});\n',
    );
  });

  it('writes a value the zod parser accepts unchanged', () => {
    const out = run({ API_URL: 'https://api.example.com:8443/v1' });
    const value = JSON.parse(/Object\.freeze\((.*)\)/.exec(out.envJs)[1]);

    expect(parseRuntimeConfig(value)).toEqual({
      ok: true,
      value: { apiUrl: 'https://api.example.com:8443/v1' },
    });
  });
});

describe('entrypoint CSP and headers', () => {
  it('limits connect-src to self and the API origin, without the API path', () => {
    const policy = csp(run({ API_URL: 'https://api.example.com:8443/v1' }).headers);

    expect(directive(policy, 'connect-src')).toBe(
      "connect-src 'self' https://api.example.com:8443",
    );
  });

  it('uses only self for a same-origin API path', () => {
    const policy = csp(run({ API_URL: '/api' }).headers);

    expect(directive(policy, 'connect-src')).toBe("connect-src 'self'");
  });

  it('keeps the fixed directives locked down', () => {
    const policy = csp(run({ API_URL: 'https://api.example.com' }).headers);

    expect(policy.split('; ')).toEqual(
      expect.arrayContaining([
        "default-src 'self'",
        "script-src 'self'",
        "object-src 'none'",
        "base-uri 'self'",
        "frame-ancestors 'none'",
      ]),
    );
    expect(policy).not.toContain('unsafe-inline');
    expect(policy).not.toContain('unsafe-eval');
    expect(policy).not.toContain('*');
  });

  it('adds the other security headers, each with always', () => {
    const { headers } = run({ API_URL: 'https://api.example.com' });

    for (const name of [
      'Content-Security-Policy',
      'X-Content-Type-Options "nosniff"',
      'X-Frame-Options "DENY"',
      'Referrer-Policy',
      'Permissions-Policy',
      'Cross-Origin-Opener-Policy',
      'Strict-Transport-Security',
    ]) {
      expect(headers).toMatch(new RegExp(`add_header ${name}[^\\n]*always;$`, 'm'));
    }
  });

  it('repeats the headers include in every location that sets its own header', () => {
    const { conf, headers } = run({ API_URL: 'https://api.example.com' });
    const includeLine = /include (\S*security-headers\.conf);/.exec(conf)[1];
    const locations = conf.split(/\n {2}location /).slice(1);

    expect(headers).toContain('Content-Security-Policy');
    expect(locations.length).toBeGreaterThan(0);
    for (const location of locations) {
      if (location.includes('add_header')) expect(location).toContain(`include ${includeLine};`);
    }
    expect(conf).toContain('listen 8080;');
    expect(conf).toContain('root /srv/www;');
    expect(conf).toContain('server_tokens off;');
  });

  it('sets the required cache policy and health endpoint', () => {
    const { conf } = run({ API_URL: 'https://api.example.com' });

    expect(conf).toContain('add_header Cache-Control "no-store" always;');
    expect(conf).toContain(
      'add_header Cache-Control "public, max-age=31536000, immutable" always;',
    );
    expect(conf).toContain('try_files $uri /index.html;');
    expect(conf).toContain('add_header Cache-Control "no-cache" always;');
    expect(conf).toContain('location = /healthz {');
    expect(conf).toContain('gzip_static on;');
    expect(conf).toContain('gzip_vary on;');
    expect(conf).toContain('return 200 "ok\\n";');
  });
});

describe('entrypoint validation (same rule as the zod parser)', () => {
  const cases = [
    'https://api.example.com',
    'https://api.example.com:8443/v1/',
    '/api',
    '/api/',
    '/',
    'http://localhost:5000',
    'http://127.0.0.1:5000/api',
    'http://[::1]:5000',
    'http://app.localhost',
    'http://api.example.com',
    'http://localhost.evil.com',
    'ftp://api.example.com',
    '//evil.example.com',
    'https://user:pass@api.example.com',
    'https://api.example.com/?a=1',
    'https://api.example.com/#frag',
    'https://api.example.com;frame-ancestors *',
    'https://api.example.com"; add_header X "y',
    'not a url',
  ];

  it.each(cases)('agrees with the parser on %j', (url) => {
    const parsed = parseRuntimeConfig({ API_URL: url });
    const out = run({ API_URL: url });

    expect(out.status === 0).toBe(parsed.ok);
    if (parsed.ok) expect(out.envJs).toContain(`"API_URL":"${parsed.value.apiUrl}"`);
    else expect(out.stderr).toContain('API_URL');
  });

  it('fails when API_URL is missing or empty, and writes nothing', () => {
    for (const env of [{}, { API_URL: '' }]) {
      const out = run(env);

      expect(out.status).toBe(1);
      expect(out.stderr).toContain('API_URL is required');
      expect(out.envJs).toBeUndefined();
      expect(out.conf).toBeUndefined();
    }
  });

  it('starts the given command after writing the files', () => {
    const out = run({ API_URL: 'https://api.example.com' }, ['echo', 'started']);

    expect(out.status).toBe(0);
    expect(out.stdout).toBe('started\n');
    expect(out.envJs).toBeDefined();
  });
});
