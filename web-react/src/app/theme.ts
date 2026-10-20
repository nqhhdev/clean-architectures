export type Theme = 'light' | 'dark';

/** The OS preference. `matchMedia` is absent in some environments (jsdom), which means light. */
export function preferredTheme(win: Pick<Window, 'matchMedia'>): Theme {
  const query = '(prefers-color-scheme: dark)';
  return typeof win.matchMedia === 'function' && win.matchMedia(query).matches ? 'dark' : 'light';
}

/** Tokens switch on the `data-theme` attribute (ADR 0011). */
export function applyTheme(root: HTMLElement, theme: Theme): void {
  root.setAttribute('data-theme', theme);
}
