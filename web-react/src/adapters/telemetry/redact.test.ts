import { redact, redactText } from './redact';

describe('redact', () => {
  it('masks sensitive keys at any depth, in arrays too, and keeps the rest', () => {
    const input = {
      path: '/emails',
      headers: { Authorization: 'Bearer abc', 'X-XSRF-TOKEN': 't', accept: 'json' },
      list: [{ sessionId: 's1', ok: 1 }],
      password: 'p',
    };

    expect(redact(input)).toEqual({
      path: '/emails',
      headers: { Authorization: '[redacted]', 'X-XSRF-TOKEN': '[redacted]', accept: 'json' },
      list: [{ sessionId: '[redacted]', ok: 1 }],
      password: '[redacted]',
    });
  });

  it('does not mutate its input', () => {
    const input = { token: 'x' };

    redact(input);

    expect(input).toEqual({ token: 'x' });
  });

  it('removes credentials from strings', () => {
    // Assembled so the secret scan does not flag a literal token in the repository.
    const jwt = ['eyJhbGciOiJIUzI1NiJ9', 'eyJzdWIiOiIxMjM0NTY3ODkwIn0', 'abcdefghijk'].join('.');

    expect(redactText('sent Bearer abc.def')).toBe('sent Bearer [redacted]');
    expect(redact({ note: `got ${jwt}` })).toEqual({ note: 'got [redacted]' });
  });

  it('keeps only name and message of errors', () => {
    const error = new Error('failed with Bearer secret123');

    expect(redact({ error })).toEqual({
      error: { name: 'Error', message: 'failed with Bearer [redacted]' },
    });
  });

  it('passes primitives through and truncates very deep or cyclic values', () => {
    const cyclic: Record<string, unknown> = {};
    cyclic.self = cyclic;

    expect(redact(42)).toBe(42);
    expect(redact(null)).toBeNull();
    expect(JSON.stringify(redact(cyclic))).toContain('[truncated]');
  });
});
