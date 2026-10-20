import type { LogContext, Logger } from '@/application/logger';

import { redact, redactText } from './redact';

type Level = 'debug' | 'info' | 'warn' | 'error';

/** Writes to the console after redacting credentials from the message and context (S4). */
export function createConsoleLogger(sink: Pick<Console, Level> = console): Logger {
  const write = (level: Level) => (message: string, context?: LogContext) => {
    if (context === undefined) sink[level](redactText(message));
    else sink[level](redactText(message), redact(context));
  };
  return { debug: write('debug'), info: write('info'), warn: write('warn'), error: write('error') };
}
