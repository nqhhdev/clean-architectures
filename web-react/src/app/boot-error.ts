/**
 * The one failure path of boot: a visible page instead of a half started app. Plain DOM and no i18n, because the
 * failure may be that nothing is configured. `textContent` only, so the message is never parsed as HTML.
 */
export function renderBootError(document: Document, message: string): void {
  const container = document.getElementById('root') ?? document.body;
  const heading = document.createElement('h1');
  heading.textContent = 'The app could not start';
  const detail = document.createElement('p');
  detail.textContent = message;
  const main = document.createElement('main');
  main.setAttribute('role', 'alert');
  main.append(heading, detail);
  container.replaceChildren(main);
}
