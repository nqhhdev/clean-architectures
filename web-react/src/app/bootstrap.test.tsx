import { screen } from '@testing-library/react';

import { createFakeServices } from '@/test/fakes/services';
import { createFakeSession } from '@/test/fakes/session';

import { mountApp } from './bootstrap';

describe('mountApp', () => {
  afterEach(() => {
    document.body.innerHTML = '';
  });

  it('throws when #root is missing', () => {
    expect(() => mountApp(createFakeServices())).toThrow('Missing #root element');
  });

  it('mounts the app into #root', async () => {
    document.body.innerHTML = '<div id="root"></div>';

    const root = mountApp(
      createFakeServices({
        session: createFakeSession({}, { user: { id: '1', displayName: 'Ada' } }),
      }),
    );

    expect(await screen.findByRole('heading', { name: 'web-react' })).toBeInTheDocument();
    root.unmount();
  });
});
