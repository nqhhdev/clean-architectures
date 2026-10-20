import { screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

import { QueryError } from '@/application/query-error';
import { createFakeSession } from '@/test/fakes/session';
import { renderApp } from '@/test/render-with-providers';

const ada = { id: '1', displayName: 'Ada' };

describe('App routing and session guard', () => {
  it('shows the home screen to a signed-in user', async () => {
    renderApp({ services: { session: createFakeSession({}, { user: ada }) } });

    expect(await screen.findByRole('heading', { name: 'web-react' })).toBeInTheDocument();
    expect(screen.getByRole('link', { name: 'Home' })).toBeInTheDocument();
  });

  it('redirects a signed-out user to the sign-in placeholder', async () => {
    const { router } = renderApp();

    expect(await screen.findByRole('heading', { name: 'Sign in' })).toBeInTheDocument();
    expect(router.state.location.pathname).toBe('/sign-in');
    expect(screen.queryByRole('heading', { name: 'web-react' })).not.toBeInTheDocument();
  });

  it('starts the session bootstrap once across guard runs and StrictMode', async () => {
    const session = createFakeSession({}, { user: ada });
    const { router } = renderApp({ services: { session } });
    await screen.findByRole('heading', { name: 'web-react' });

    await router.navigate({ to: '/' });
    await router.invalidate();

    expect(session.bootstrapCalls()).toBe(1);
  });

  it('redirects to sign-in after sign out', async () => {
    renderApp({ services: { session: createFakeSession({}, { user: ada }) } });

    await userEvent.click(await screen.findByRole('button', { name: 'Sign out' }));

    expect(await screen.findByRole('heading', { name: 'Sign in' })).toBeInTheDocument();
  });

  it('renders the not-found component for an unknown path', async () => {
    renderApp({ path: '/nope' });

    expect(await screen.findByRole('heading', { name: 'Page not found' })).toBeInTheDocument();
  });

  it('shows an error component when the session bootstrap fails, and recovers on retry', async () => {
    const spy = vi.spyOn(console, 'error').mockImplementation(() => undefined);
    let fail = true;
    const session = createFakeSession(
      {
        bootstrap: () => (fail ? Promise.reject(new Error('boom')) : Promise.resolve()),
      },
      { user: ada },
    );
    renderApp({ services: { session } });

    expect(
      await screen.findByRole('heading', { name: 'Something went wrong' }),
    ).toBeInTheDocument();

    fail = false;
    await userEvent.click(screen.getByRole('button', { name: 'Try again' }));
    expect(await screen.findByRole('heading', { name: 'web-react' })).toBeInTheDocument();
    spy.mockRestore();
  });

  it('says the server cannot be reached when the session bootstrap gets a network error', async () => {
    const spy = vi.spyOn(console, 'error').mockImplementation(() => undefined);
    const session = createFakeSession({
      bootstrap: () => Promise.reject(new QueryError({ kind: 'network' })),
    });
    renderApp({ services: { session } });

    expect(await screen.findByText(/The service is unreachable/)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Try again' })).toBeInTheDocument();
    spy.mockRestore();
  });
});
