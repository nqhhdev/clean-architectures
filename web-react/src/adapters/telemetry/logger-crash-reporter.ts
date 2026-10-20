import type { CrashReporter } from '@/application/crash-reporter';
import type { Logger } from '@/application/logger';

/** Crash reporter that writes through the `Logger`; a hosted service replaces it behind the same port. */
export function createLoggerCrashReporter(logger: Logger): CrashReporter {
  return {
    report(error, context) {
      const detail =
        error instanceof Error
          ? { name: error.name, message: error.message }
          : { message: String(error) };
      logger.error('Unhandled error', { ...detail, ...context });
    },
  };
}
