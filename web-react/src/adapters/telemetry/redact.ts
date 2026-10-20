const REDACTED = '[redacted]';
const MAX_DEPTH = 5;

// Names that hold credentials or session material (S4). Matched anywhere in a key, case-insensitively.
const SENSITIVE_KEY =
  /token|authorization|cookie|password|passwd|secret|csrf|xsrf|session|api[-_]?key|credential/i;
// Credentials that slip into free text: bearer headers and JSON web tokens.
const BEARER = /\bBearer\s+[A-Za-z0-9._~+/-]+=*/g;
const JWT = /\beyJ[A-Za-z0-9_-]{8,}\.eyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}/g;

export function redactText(text: string): string {
  return text.replace(BEARER, `Bearer ${REDACTED}`).replace(JWT, REDACTED);
}

/** Copy of `value` with sensitive keys masked and credentials removed from strings; never mutates the input. */
export function redact(value: unknown, depth = 0): unknown {
  if (typeof value === 'string') return redactText(value);
  if (typeof value !== 'object' || value === null) return value;
  if (depth >= MAX_DEPTH) return '[truncated]';
  if (Array.isArray(value)) return value.map((item) => redact(item, depth + 1));
  if (value instanceof Error) return { name: value.name, message: redactText(value.message) };
  return Object.fromEntries(
    Object.entries(value).map(([key, item]) => [
      key,
      SENSITIVE_KEY.test(key) ? REDACTED : redact(item, depth + 1),
    ]),
  );
}
