import type { CrashReporter } from '@/application/crash-reporter';
import type { Logger } from '@/application/logger';

export function createFakeLogger(): Logger {
  return {
    debug: () => undefined,
    info: () => undefined,
    warn: () => undefined,
    error: () => undefined,
  };
}

export interface FakeCrashReporter extends CrashReporter {
  reported: { error: unknown; context?: Record<string, unknown> | undefined }[];
}

export function createFakeCrashReporter(): FakeCrashReporter {
  const reported: FakeCrashReporter['reported'] = [];
  return {
    reported,
    report: (error, context) => {
      reported.push({ error, context });
    },
  };
}
