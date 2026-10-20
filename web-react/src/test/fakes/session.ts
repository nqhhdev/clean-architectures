import type { SessionService, SessionSnapshot } from '@/application/session';

export interface FakeSession extends SessionService {
  /** Replaces the snapshot and notifies subscribers, as a real adapter would. */
  set: (next: SessionSnapshot) => void;
  /** How many times `bootstrap` ran. */
  bootstrapCalls: () => number;
}

export function createFakeSession(
  overrides: Partial<SessionService> = {},
  initial: SessionSnapshot = { user: null },
): FakeSession {
  let snapshot = initial;
  let bootstraps = 0;
  const listeners = new Set<() => void>();

  const set = (next: SessionSnapshot) => {
    snapshot = next;
    listeners.forEach((listener) => {
      listener();
    });
  };

  return {
    getSnapshot: () => snapshot,
    subscribe: (listener) => {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
    bootstrap: () => {
      bootstraps += 1;
      return Promise.resolve();
    },
    signOut: () => {
      set({ user: null });
      return Promise.resolve();
    },
    expire: () => {
      if (snapshot.user) set({ user: null });
    },
    ...overrides,
    set,
    bootstrapCalls: () => bootstraps,
  };
}
