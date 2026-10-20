import { QueryClientProvider, type QueryClient } from '@tanstack/react-query';
import { RouterProvider } from '@tanstack/react-router';
import type { i18n as I18n } from 'i18next';
import { useEffect, type ReactNode } from 'react';
import { I18nextProvider } from 'react-i18next';

import type { Services } from '@/application/services';

import type { AppRouter } from './router';
import { ServicesContext, useServices } from './services/services-context';

export function AppProviders({
  services,
  queryClient,
  i18n,
  children,
}: {
  services: Services;
  queryClient: QueryClient;
  i18n: I18n;
  children: ReactNode;
}) {
  return (
    <ServicesContext value={services}>
      <I18nextProvider i18n={i18n}>
        <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
      </I18nextProvider>
    </ServicesContext>
  );
}

export function App({ router }: { router: AppRouter }) {
  const { session: service } = useServices();
  // The router does not watch the session: a change re-runs the `beforeLoad` guards, so sign-out redirects.
  useEffect(
    () =>
      service.subscribe(() => {
        void router.invalidate();
      }),
    [router, service],
  );
  return <RouterProvider router={router} />;
}
