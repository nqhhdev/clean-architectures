import { createFakeSession } from '@/test/fakes/session';

import { bootstrapSession } from './session-bootstrap';

describe('bootstrapSession', () => {
  it('starts the service once and shares the promise', async () => {
    const session = createFakeSession();

    const first = bootstrapSession(session);
    const second = bootstrapSession(session);
    await Promise.all([first, second]);

    expect(second).toBe(first);
    expect(session.bootstrapCalls()).toBe(1);
  });

  it('forgets a failed start so the next call retries', async () => {
    let fail = true;
    const session = createFakeSession({
      bootstrap: () => (fail ? Promise.reject(new Error('boom')) : Promise.resolve()),
    });

    await expect(bootstrapSession(session)).rejects.toThrow('boom');
    fail = false;
    await expect(bootstrapSession(session)).resolves.toBeUndefined();
  });
});
