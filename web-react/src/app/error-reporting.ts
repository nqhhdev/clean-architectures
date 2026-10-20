import type { CrashReporter } from '@/application/crash-reporter';

type Target = Pick<Window, 'addEventListener' | 'removeEventListener'>;

/**
 * Sends errors that no boundary caught to the `CrashReporter`: script errors and unhandled promise rejections.
 * Returns the function that removes the listeners.
 */
export function installGlobalErrorHandlers(target: Target, reporter: CrashReporter): () => void {
  const onError = (event: ErrorEvent) => {
    reporter.report(event.error ?? event.message, { source: 'window.onerror' });
  };
  const onRejection = (event: PromiseRejectionEvent) => {
    reporter.report(event.reason, { source: 'unhandledrejection' });
  };
  target.addEventListener('error', onError);
  target.addEventListener('unhandledrejection', onRejection);
  return () => {
    target.removeEventListener('error', onError);
    target.removeEventListener('unhandledrejection', onRejection);
  };
}
