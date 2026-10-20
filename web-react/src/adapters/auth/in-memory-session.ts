import type { SessionService, SessionSnapshot, SessionUser } from '@/application/session';

/**
 * Session held in memory, with no storage and no token. Used by `main.mock.tsx` with a demo user; the real
 * composition root uses `createCookieSession`.
 */
export function createInMemorySession(user: SessionUser | null = null): SessionService {
  let snapshot: SessionSnapshot = { user };
  const listeners = new Set<() => void>();

  const clear = () => {
    snapshot = { user: null };
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
    bootstrap: () => Promise.resolve(),
    signOut: () => {
      clear();
      return Promise.resolve();
    },
    expire: () => {
      if (snapshot.user) clear();
    },
  };
}
