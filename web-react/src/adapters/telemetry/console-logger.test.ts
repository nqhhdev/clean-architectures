import { createConsoleLogger } from './console-logger';

describe('createConsoleLogger', () => {
  it('forwards the message and context to the matching console method', () => {
    const sink = { debug: vi.fn(), info: vi.fn(), warn: vi.fn(), error: vi.fn() };
    const logger = createConsoleLogger(sink);

    logger.warn('slow', { ms: 900 });
    logger.info('started');

    expect(sink.warn).toHaveBeenCalledWith('slow', { ms: 900 });
    expect(sink.info).toHaveBeenCalledWith('started');
  });

  it('redacts credentials from the message and context', () => {
    const sink = { debug: vi.fn(), info: vi.fn(), warn: vi.fn(), error: vi.fn() };
    const logger = createConsoleLogger(sink);

    logger.error('failed with Bearer abc123', { token: 'secret', status: 500 });

    expect(sink.error).toHaveBeenCalledWith('failed with Bearer [redacted]', {
      token: '[redacted]',
      status: 500,
    });
  });
});
