import { QueryClient } from '@tanstack/react-query';
import {
  RouterProvider,
  createMemoryHistory,
  createRootRouteWithContext,
  createRouter,
} from '@tanstack/react-router';
import { render } from '@testing-library/react';
import { StrictMode, type ReactNode } from 'react';

import { App, AppProviders } from '@/app/App';
import { createI18n } from '@/app/i18n';
import { createQueryClient } from '@/app/query-client';
import { createAppRouter, type RouterContext } from '@/app/router';
import type { Services } from '@/application/services';

import { createFakeServices } from './fakes/services';

export interface RenderOptions {
  /** Whole ports replaced; every other port keeps its default fake. */
  services?: Partial<Services>;
  /** Initial memory-history location. */
  path?: string;
}

function createTestQueryClient(): QueryClient {
  const client = createQueryClient();
  const defaults = client.getDefaultOptions();
  client.setDefaultOptions({ ...defaults, queries: { ...defaults.queries, retry: false } });
  return client;
}

function setup({ services: overrides, path = '/' }: RenderOptions) {
  const services = createFakeServices(overrides);
  const queryClient = createTestQueryClient();
  const history = createMemoryHistory({ initialEntries: [path] });
  return { services, queryClient, history };
}

/** Renders the real route tree (guard, shell, error components) with fake ports (ADR 0017). */
export function renderApp(options: RenderOptions = {}) {
  const { services, queryClient, history } = setup(options);
  const router = createAppRouter({ queryClient, services, history });
  const view = render(
    <StrictMode>
      <AppProviders services={services} queryClient={queryClient} i18n={createI18n()}>
        <App router={router} />
      </AppProviders>
    </StrictMode>,
  );
  return { ...view, router, queryClient, services };
}

function createTestRouter(ui: ReactNode, context: RouterContext, path: string) {
  const root = createRootRouteWithContext<RouterContext>()({ component: () => ui });
  return createRouter({
    routeTree: root,
    context,
    history: createMemoryHistory({ initialEntries: [path] }),
  });
}

/** Renders one component under real providers, a memory-history router and default fake ports. */
export function renderWithProviders(ui: ReactNode, options: RenderOptions = {}) {
  const { services, queryClient } = setup(options);
  const router = createTestRouter(ui, { queryClient, services }, options.path ?? '/');
  const view = render(
    <StrictMode>
      <AppProviders services={services} queryClient={queryClient} i18n={createI18n()}>
        <RouterProvider router={router} />
      </AppProviders>
    </StrictMode>,
  );
  return { ...view, router, queryClient, services };
}
