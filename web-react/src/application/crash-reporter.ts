export interface CrashReporter {
  report(error: unknown, context?: Record<string, unknown>): void;
}
