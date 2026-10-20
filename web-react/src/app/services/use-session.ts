import { useSyncExternalStore } from 'react';

import type { SessionSnapshot } from '@/application/session';

import { useServices } from './services-context';

export function useSession(): SessionSnapshot {
  const { session } = useServices();
  return useSyncExternalStore(session.subscribe, session.getSnapshot);
}
