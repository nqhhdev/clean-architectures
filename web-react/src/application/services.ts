import type { CrashReporter } from './crash-reporter';
import type { EmailsPort } from './emails';
import type { Logger } from './logger';
import type { SessionService } from './session';

export interface Services {
  session: SessionService;
  emails: EmailsPort;
  logger: Logger;
  crashReporter: CrashReporter;
}
