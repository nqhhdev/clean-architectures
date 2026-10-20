import { errorKey } from './error-key';

describe('errorKey', () => {
  it('maps each kind to errors.<kind>, ignoring status and code', () => {
    expect(errorKey({ kind: 'refused', status: 403, code: 'forbidden' })).toBe('errors.refused');
    expect(errorKey({ kind: 'network' })).toBe('errors.network');
  });
});
