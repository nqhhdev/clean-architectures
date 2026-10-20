import { afterEach, describe, expect, it } from 'vitest';

import { renderBootError } from './boot-error';

afterEach(() => {
  document.body.replaceChildren();
});

describe('renderBootError', () => {
  it('shows the message in #root as text, never as HTML', () => {
    document.body.innerHTML = '<div id="root"><p>loading</p></div>';

    renderBootError(document, '<img src=x onerror=alert(1)>');

    const root = document.getElementById('root');
    expect(root?.querySelector('[role="alert"] h1')?.textContent).toBe('The app could not start');
    expect(root?.querySelector('p')?.textContent).toBe('<img src=x onerror=alert(1)>');
    expect(root?.querySelector('img')).toBeNull();
    expect(root?.textContent).not.toContain('loading');
  });

  it('falls back to the body when #root is missing', () => {
    renderBootError(document, 'boom');

    expect(document.body.querySelector('[role="alert"]')).not.toBeNull();
  });
});
