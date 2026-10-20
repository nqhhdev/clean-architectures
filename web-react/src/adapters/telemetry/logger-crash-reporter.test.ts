import type { Logger } from '@/application/logger';

import { createLoggerCrashReporter } from './logger-crash-reporter';

function fakeLogger() {
  const error = vi.fn();
  const logger: Logger = { debug: vi.fn(), info: vi.fn(), warn: vi.fn(), error };
  return { logger, error };
}

describe('createLoggerCrashReporter', () => {
  it('logs the name and message of an Error with its context, not the stack', () => {
    const { logger, error } = fakeLogger();
    createLoggerCrashReporter(logger).report(new TypeError('boom'), { source: 'window' });

    expect(error).toHaveBeenCalledWith('Unhandled error', {
      name: 'TypeError',
      message: 'boom',
      source: 'window',
    });
  });

  it('stringifies a non-Error value', () => {
    const { logger, error } = fakeLogger();
    createLoggerCrashReporter(logger).report('oops');

    expect(error).toHaveBeenCalledWith('Unhandled error', { message: 'oops' });
  });
});
