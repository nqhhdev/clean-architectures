import type { QueryClient } from '@tanstack/react-query';
import {
  Outlet,
  createRootRouteWithContext,
  createRoute,
  createRouter,
  redirect,
  type RouterHistory,
} from '@tanstack/react-router';

import type { Services } from '@/application/services';
import { EmailsScreen } from '@/features/emails/emails-screen';
import { emailsQueryOptions } from '@/features/emails/queries';
import { HomeScreen } from '@/features/home/home-screen';

import { NotFound, RootError, Shell, SignInPlaceholder } from './route-components';
import { bootstrapSession } from './session-bootstrap';

export interface RouterContext {
  queryClient: QueryClient;
  services: Services;
}

const rootRoute = createRootRouteWithContext<RouterContext>()({
  component: Outlet,
  errorComponent: RootError,
  notFoundComponent: NotFound,
});

const signInRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/sign-in',
  component: SignInPlaceholder,
});

// Authenticated layout: the guard lives in `beforeLoad`, never in a component effect (ADR 0013).
const shellRoute = createRoute({
  getParentRoute: () => rootRoute,
  id: 'shell',
  beforeLoad: async ({ context }) => {
    const { session } = context.services;
    await bootstrapSession(session);
    if (!session.getSnapshot().user) throw redirect({ to: '/sign-in' });
  },
  component: Shell,
  errorComponent: RootError,
});

const homeRoute = createRoute({
  getParentRoute: () => shellRoute,
  path: '/',
  component: HomeScreen,
});

const emailsRoute = createRoute({
  getParentRoute: () => shellRoute,
  path: '/emails',
  // Loaders take services from router context, never from a hook (ADR 0013).
  loader: ({ context }) =>
    context.queryClient.query({ ...emailsQueryOptions(context.services), staleTime: 'static' }),
  component: EmailsScreen,
});

const routeTree = rootRoute.addChildren([
  signInRoute,
  shellRoute.addChildren([homeRoute, emailsRoute]),
]);

export interface CreateAppRouterOptions {
  queryClient: QueryClient;
  services: Services;
  history?: RouterHistory;
}

export function createAppRouter({ queryClient, services, history }: CreateAppRouterOptions) {
  return createRouter({
    routeTree,
    context: { queryClient, services },
    ...(history ? { history } : {}),
  });
}

export type AppRouter = ReturnType<typeof createAppRouter>;

declare module '@tanstack/react-router' {
  interface Register {
    router: AppRouter;
  }
}
