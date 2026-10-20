// Client-side security rules (ADR 0019: S3 token storage, XSS). Kept apart from eslint.config.js so the rule
// self-test (src/test/security-lint.test.ts) can load exactly these rules without type-aware parsing.
import tseslint from 'typescript-eslint';

const STORAGE = '/^(localStorage|sessionStorage)$/';

export default [
  {
    files: ['src/**/*.{ts,tsx}'],
    languageOptions: { parser: tseslint.parser },
    rules: {
      'no-restricted-syntax': [
        'error',
        {
          selector: `Identifier[name=${STORAGE}]`,
          message:
            'No localStorage or sessionStorage: the session is an httpOnly cookie (ADR 0009, 0019).',
        },
        {
          selector: `Literal[value=${STORAGE}]`,
          message:
            'No localStorage or sessionStorage: the session is an httpOnly cookie (ADR 0009, 0019).',
        },
        {
          selector:
            "AssignmentExpression[left.type='MemberExpression'][left.property.name='cookie']",
          message: 'Script must not write cookies: the API sets them httpOnly (ADR 0009, 0019).',
        },
        {
          selector:
            "JSXAttribute[name.name='dangerouslySetInnerHTML'], Property[key.name='dangerouslySetInnerHTML']",
          message: 'Rendering HTML needs a sanitizer decision first (ADR 0019).',
        },
      ],
    },
  },
];
