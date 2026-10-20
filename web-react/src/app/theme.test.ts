import { applyTheme, preferredTheme } from './theme';

const media = (matches: boolean) => (() => ({ matches })) as unknown as Window['matchMedia'];

describe('theme', () => {
  it('follows the OS preference', () => {
    expect(preferredTheme({ matchMedia: media(true) })).toBe('dark');
    expect(preferredTheme({ matchMedia: media(false) })).toBe('light');
  });

  it('falls back to light without matchMedia', () => {
    expect(preferredTheme({} as Window)).toBe('light');
  });

  it('sets data-theme on the root element', () => {
    applyTheme(document.documentElement, 'dark');

    expect(document.documentElement).toHaveAttribute('data-theme', 'dark');
  });
});
