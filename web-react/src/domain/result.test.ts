import { err, ok, type Result } from './result';

function parse(input: string): Result<number, string> {
  const value = Number(input);
  return Number.isNaN(value) ? err('not a number') : ok(value);
}

describe('Result', () => {
  it('ok carries the value', () => {
    expect(ok(1)).toEqual({ ok: true, value: 1 });
  });

  it('err carries the error', () => {
    expect(err('boom')).toEqual({ ok: false, error: 'boom' });
  });

  it('narrows on ok', () => {
    const good = parse('2');
    const bad = parse('x');

    expect(good.ok && good.value).toBe(2);
    expect(!bad.ok && bad.error).toBe('not a number');
  });
});
