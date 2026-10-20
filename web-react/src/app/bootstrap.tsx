import { StrictMode } from 'react';
import { createRoot, type Root } from 'react-dom/client';

import '@/ds/tokens.css';
import type { Services } from '@/application/services';

import { App, AppProviders } from './App';
import { installGlobalErrorHandlers } from './error-reporting';
import { createI18n } from './i18n';
import { createQueryClient } from './query-client';
import { createAppRouter } from './router';
import { applyTheme, preferredTheme } from './theme';

/** Shared by `main.tsx` and `main.mock.tsx`: they differ only in the `Services` they build (ADR 0010). */
export function mountApp(services: Services): Root {
  const container = document.getElementById('root');
  if (!container) throw new Error('Missing #root element');

  applyTheme(document.documentElement, preferredTheme(window));
  installGlobalErrorHandlers(window, services.crashReporter);

  const queryClient = createQueryClient();
  const router = createAppRouter({ queryClient, services });
  const root = createRoot(container, {
    // Errors no boundary caught; caught ones are reported by the error components.
    onUncaughtError: (error) => {
      services.crashReporter.report(error, { source: 'react.uncaught' });
    },
  });
  root.render(
    <StrictMode>
      <AppProviders services={services} queryClient={queryClient} i18n={createI18n()}>
        <App router={router} />
      </AppProviders>
    </StrictMode>,
  );
  return root;
}
