import { describe, expect, it } from 'vitest';
import { z } from 'zod';

import { parseRuntimeConfig, readRuntimeConfig } from './runtime-config';
import './zod-config';

function apiUrl(value: unknown) {
  return parseRuntimeConfig({ API_URL: value });
}

describe('parseRuntimeConfig', () => {
  it('accepts an https URL and drops the trailing slash', () => {
    expect(apiUrl('https://api.example.com/')).toEqual({
      ok: true,
      value: { apiUrl: 'https://api.example.com' },
    });
    expect(apiUrl('https://api.example.com:8443/v1')).toEqual({
      ok: true,
      value: { apiUrl: 'https://api.example.com:8443/v1' },
    });
  });

  it('accepts a same-origin path', () => {
    expect(apiUrl('/api')).toEqual({ ok: true, value: { apiUrl: '/api' } });
    expect(apiUrl('/api/')).toEqual({ ok: true, value: { apiUrl: '/api' } });
  });

  it.each([
    'http://localhost:5000',
    'http://127.0.0.1:5000/api',
    'http://[::1]:5000',
    'http://app.localhost',
  ])('allows plain http for the local host %s', (url) => {
    expect(apiUrl(url).ok).toBe(true);
  });

  it.each(['http://api.example.com', 'http://localhost.evil.com', 'ftp://api.example.com'])(
    'rejects %s: https is required for non-local hosts',
    (url) => {
      expect(apiUrl(url)).toEqual({ ok: false, error: expect.stringContaining('https') as string });
    },
  );

  it.each([
    'https://user:pass@api.example.com',
    'https://api.example.com/?a=1',
    'https://api.example.com/#frag',
  ])('rejects %s: no credentials, query or fragment', (url) => {
    expect(apiUrl(url).ok).toBe(false);
  });

  it.each(['not a url', '//evil.example.com', '/', '', 42, null, undefined])(
    'rejects %j',
    (value) => {
      expect(apiUrl(value).ok).toBe(false);
    },
  );

  it('fails when nothing is configured and no fallback is given', () => {
    expect(parseRuntimeConfig(undefined).ok).toBe(false);
    expect(parseRuntimeConfig({}).ok).toBe(false);
    expect(parseRuntimeConfig('nope').ok).toBe(false);
  });

  it('uses the fallback only when API_URL is absent, and still validates it', () => {
    expect(parseRuntimeConfig({}, { fallbackApiUrl: '/api' })).toEqual({
      ok: true,
      value: { apiUrl: '/api' },
    });
    expect(
      parseRuntimeConfig({ API_URL: 'http://evil.example.com' }, { fallbackApiUrl: '/api' }).ok,
    ).toBe(false);
    expect(parseRuntimeConfig({}, { fallbackApiUrl: 'http://evil.example.com' }).ok).toBe(false);
  });
});

describe('readRuntimeConfig', () => {
  it('parses window.__ENV__', () => {
    expect(readRuntimeConfig({ __ENV__: { API_URL: 'https://api.example.com' } })).toEqual({
      ok: true,
      value: { apiUrl: 'https://api.example.com' },
    });
    expect(readRuntimeConfig({}).ok).toBe(false);
  });
});

describe('zod config', () => {
  it('parses without eval so the CSP has no script-src violation', () => {
    expect(z.config().jitless).toBe(true);
  });
});
