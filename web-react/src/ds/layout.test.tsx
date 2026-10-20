import { render, screen } from '@testing-library/react';

import { Heading } from './heading';
import { Inline, Page, Stack } from './layout';

describe('layout primitives', () => {
  it('Page renders a main landmark around its children', () => {
    render(
      <Page>
        <Heading>Title</Heading>
      </Page>,
    );

    expect(screen.getByRole('main')).toContainElement(
      screen.getByRole('heading', { name: 'Title' }),
    );
  });

  it('Stack and Inline render their children, in the element asked for', () => {
    render(
      <>
        <Stack as="ul" gap={2}>
          <li>one</li>
        </Stack>
        <Inline as="nav">
          <a href="/">home</a>
        </Inline>
      </>,
    );

    expect(screen.getByRole('list')).toBeInTheDocument();
    expect(screen.getByRole('navigation')).toBeInTheDocument();
  });

  it('Stack and Inline default to a div', () => {
    const { container } = render(
      <Stack>
        <Inline>x</Inline>
      </Stack>,
    );

    expect(container.querySelectorAll('div')).toHaveLength(2);
  });
});
