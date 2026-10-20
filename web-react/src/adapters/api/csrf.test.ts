import { createCsrfHeaders } from './csrf';

describe('createCsrfHeaders', () => {
  it('copies the CSRF cookie into the default header', () => {
    const headers = createCsrfHeaders({
      readCookies: () => 'theme=dark; XSRF-TOKEN=abc%3D123; a=b',
    });

    expect(headers()).toEqual({ 'X-XSRF-TOKEN': 'abc=123' });
  });

  it('honours custom cookie and header names', () => {
    const headers = createCsrfHeaders({
      cookieName: 'csrf',
      headerName: 'X-CSRF',
      readCookies: () => 'csrf=v=1',
    });

    expect(headers()).toEqual({ 'X-CSRF': 'v=1' });
  });

  it('adds nothing when the cookie is absent', () => {
    expect(createCsrfHeaders({ readCookies: () => 'theme=dark' })()).toEqual({});
    expect(createCsrfHeaders({ readCookies: () => '' })()).toEqual({});
  });

  it('reads document.cookie by default', () => {
    expect(createCsrfHeaders()()).toEqual({});
  });
});
