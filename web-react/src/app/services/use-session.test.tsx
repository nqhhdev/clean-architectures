import { act, render, screen } from '@testing-library/react';

import { renderWithProviders } from '@/test/render-with-providers';
import { createFakeSession } from '@/test/fakes/session';

import { useServices } from './services-context';
import { useSession } from './use-session';

function Who() {
  const { user } = useSession();
  return <p>{user ? user.displayName : 'signed out'}</p>;
}

function Probe() {
  useServices();
  return null;
}

describe('app/services', () => {
  it('useSession follows the session service', async () => {
    const session = createFakeSession();
    renderWithProviders(<Who />, { services: { session } });
    expect(await screen.findByText('signed out')).toBeInTheDocument();

    act(() => {
      session.set({ user: { id: '1', displayName: 'Ada' } });
    });
    expect(screen.getByText('Ada')).toBeInTheDocument();
  });

  it('useServices throws outside a provider', () => {
    const spy = vi.spyOn(console, 'error').mockImplementation(() => undefined);
    expect(() => render(<Probe />)).toThrow('useServices must be used inside');
    spy.mockRestore();
  });
});
