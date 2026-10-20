export interface SessionUser {
  id: string;
  displayName: string;
}

export interface SessionSnapshot {
  user: SessionUser | null;
}

// Property signatures, not methods: the members are passed unbound to `useSyncExternalStore`.
export interface SessionService {
  getSnapshot: () => SessionSnapshot;
  subscribe: (listener: () => void) => () => void;
  bootstrap: () => Promise<void>;
  signOut: () => Promise<void>;
  /** Drops the user without a server call: the API already ended the session (a 401). Idempotent. */
  expire: () => void;
}
