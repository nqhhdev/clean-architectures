import { installGlobalErrorHandlers } from './error-reporting';

describe('installGlobalErrorHandlers', () => {
  it('reports script errors and unhandled rejections until removed', () => {
    const report = vi.fn();
    const target = new EventTarget() as unknown as Window;
    const remove = installGlobalErrorHandlers(target, { report });

    const failure = new Error('boom');
    target.dispatchEvent(Object.assign(new Event('error'), { error: failure, message: 'boom' }));
    target.dispatchEvent(Object.assign(new Event('unhandledrejection'), { reason: 'nope' }));
    expect(report).toHaveBeenNthCalledWith(1, failure, { source: 'window.onerror' });
    expect(report).toHaveBeenNthCalledWith(2, 'nope', { source: 'unhandledrejection' });

    remove();
    target.dispatchEvent(Object.assign(new Event('error'), { error: failure }));
    expect(report).toHaveBeenCalledTimes(2);
  });

  it('falls back to the message when the event carries no error object', () => {
    const report = vi.fn();
    const target = new EventTarget() as unknown as Window;
    installGlobalErrorHandlers(target, { report });

    target.dispatchEvent(Object.assign(new Event('error'), { message: 'Script error.' }));

    expect(report).toHaveBeenCalledWith('Script error.', { source: 'window.onerror' });
  });
});
