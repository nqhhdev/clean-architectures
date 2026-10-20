import type { SessionService } from '@/application/session';

const started = new WeakMap<SessionService, Promise<void>>();

/**
 * Starts `session.bootstrap()` at most once per service, however often a route guard runs or StrictMode doubles a
 * start (ADR 0014). A failed start is forgotten so the next navigation can retry.
 */
export function bootstrapSession(session: SessionService): Promise<void> {
  const existing = started.get(session);
  if (existing) return existing;

  const promise = session.bootstrap().catch((error: unknown) => {
    started.delete(session);
    throw error;
  });
  started.set(session, promise);
  return promise;
}
