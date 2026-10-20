import { GetSessionResponse } from '@/adapters/api/generated/emails.zod';
import type { HttpClient } from '@/adapters/api/http-client';
import { QueryError } from '@/application/query-error';
import type { SessionService, SessionSnapshot } from '@/application/session';

/**
 * Session backed by the API's httpOnly cookie (ADR 0009, 0014). The browser attaches the cookie; this adapter keeps
 * only the user the API reports, never a token, and writes nothing to storage.
 *
 * Wiring: the HTTP client's `onUnauthorized` calls `expire()`, so a 401 anywhere ends the session in one place.
 */
export function createCookieSession(http: HttpClient): SessionService {
  let snapshot: SessionSnapshot = { user: null };
  const listeners = new Set<() => void>();

  const set = (next: SessionSnapshot) => {
    if (!snapshot.user && !next.user) return;
    snapshot = next;
    listeners.forEach((listener) => {
      listener();
    });
  };

  const expire = () => {
    set({ user: null });
  };

  return {
    getSnapshot: () => snapshot,
    subscribe: (listener) => {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
    async bootstrap() {
      const result = await http.get('/session', GetSessionResponse);
      if (result.ok) set({ user: result.value });
      // No cookie or an expired one is a signed-out start, not a failure.
      else if (result.error.kind === 'unauthorized') expire();
      // Anything else fails the start: the error boundary shows the kind ("service unreachable" for `network`) with a
      // retry, and a later navigation retries too.
      else throw new QueryError(result.error);
    },
    async signOut() {
      const result = await http.delete('/session');
      // A sign-out the API did not perform must not look done.
      if (!result.ok && result.error.kind !== 'unauthorized') {
        throw new Error(`Sign-out failed: ${result.error.kind}`);
      }
      expire();
    },
    expire,
  };
}
