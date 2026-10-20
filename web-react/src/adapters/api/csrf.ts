export interface CsrfOptions {
  /** Cookie the API sets for script to read (double-submit). Not the session cookie, which is httpOnly. */
  cookieName?: string;
  headerName?: string;
  readCookies?: () => string;
}

/**
 * The CSRF hook for `createHttpClient` (ADR 0009): copies the API's CSRF cookie into a request header. Names default
 * to the common XSRF convention and are agreed per project with the API, which validates the header.
 */
export function createCsrfHeaders({
  cookieName = 'XSRF-TOKEN',
  headerName = 'X-XSRF-TOKEN',
  readCookies = () => document.cookie,
}: CsrfOptions = {}): () => Record<string, string> {
  return () => {
    for (const pair of readCookies().split(';')) {
      const [name, ...rest] = pair.trim().split('=');
      if (name === cookieName && rest.length > 0) {
        return { [headerName]: decodeURIComponent(rest.join('=')) };
      }
    }
    return {};
  };
}
