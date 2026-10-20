import type { Services } from '@/application/services';

import { createFakeEmails } from './emails';
import { createFakeCrashReporter, createFakeLogger } from './logger';
import { createFakeSession } from './session';

/** Default fakes for every port, with whole ports replaced by `overrides`. */
export function createFakeServices(overrides: Partial<Services> = {}): Services {
  return {
    session: createFakeSession(),
    emails: createFakeEmails(),
    logger: createFakeLogger(),
    crashReporter: createFakeCrashReporter(),
    ...overrides,
  };
}
