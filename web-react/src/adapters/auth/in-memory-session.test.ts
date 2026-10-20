import { createInMemorySession } from './in-memory-session';

const ada = { id: '1', displayName: 'Ada' };

describe('createInMemorySession', () => {
  it('starts signed out by default', () => {
    expect(createInMemorySession().getSnapshot()).toEqual({ user: null });
  });

  it('starts with the given user and resolves bootstrap', async () => {
    const session = createInMemorySession(ada);

    await expect(session.bootstrap()).resolves.toBeUndefined();
    expect(session.getSnapshot()).toEqual({ user: ada });
  });

  it('signOut clears the user and notifies subscribers until they unsubscribe', async () => {
    const session = createInMemorySession(ada);
    let calls = 0;
    const unsubscribe = session.subscribe(() => {
      calls += 1;
    });

    await session.signOut();
    expect(session.getSnapshot()).toEqual({ user: null });
    expect(calls).toBe(1);

    unsubscribe();
    await session.signOut();
    expect(calls).toBe(1);
  });

  it('expire clears the user and notifies once; a second call does nothing', () => {
    const session = createInMemorySession(ada);
    const listener = vi.fn();
    session.subscribe(listener);

    session.expire();
    session.expire();

    expect(session.getSnapshot()).toEqual({ user: null });
    expect(listener).toHaveBeenCalledTimes(1);
  });
});
