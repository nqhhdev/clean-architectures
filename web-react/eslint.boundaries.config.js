// Allow-matrix of ADR 0010, kept apart from eslint.config.js so the rule self-test
// (src/test/boundaries.test.ts) can load exactly these rules without type-aware parsing.
import boundaries from 'eslint-plugin-boundaries';
import tseslint from 'typescript-eslint';

const FRAMEWORK_MODULES = [
  'react',
  'react/*',
  'react-dom',
  'react-dom/*',
  '@tanstack/*',
  'zod',
  'i18next',
  'react-i18next',
  'msw',
  'msw/*',
];

// `ds/` takes already translated props and knows no domain (ADR 0011): React is its only framework import.
const DS_BANNED_MODULES = FRAMEWORK_MODULES.filter((m) => !/^react(-dom)?(\/\*)?$/.test(m));

const everything = [
  'domain',
  'application',
  'adapters',
  'ds',
  'features',
  'app-services',
  'app',
  'locales',
];

/** @param {string} type @param {string[]} to */
const allow = (type, to) => ({
  from: { element: { type } },
  allow: { to: { element: { type: [type, ...to] } } },
});

export default [
  {
    files: ['src/**/*.{ts,tsx}'],
    languageOptions: { parser: tseslint.parser },
    plugins: { boundaries },
    settings: {
      // Resolves the `@/` alias through `tsconfig.json` paths and honours package `exports` (`msw/browser`).
      'import/resolver': { typescript: { project: './tsconfig.json' } },
      'boundaries/elements': [
        { type: 'domain', pattern: 'src/domain', partialMatch: false },
        { type: 'application', pattern: 'src/application', partialMatch: false },
        { type: 'adapters', pattern: 'src/adapters', partialMatch: false },
        { type: 'ds', pattern: 'src/ds', partialMatch: false },
        { type: 'features', pattern: 'src/features/*', capture: ['feature'], partialMatch: false },
        { type: 'app-services', pattern: 'src/app/services', partialMatch: false },
        { type: 'app', pattern: 'src/app', partialMatch: false },
        { type: 'locales', pattern: 'src/locales', partialMatch: false },
      ],
      'boundaries/files': [
        { pattern: ['src/test/**', 'src/**/*.test.{ts,tsx}'], category: 'test' },
        // Composition roots: single files, so a file category rather than an element.
        { pattern: ['src/main.tsx', 'src/main.mock.tsx'], category: 'root' },
      ],
    },
    rules: {
      'boundaries/dependencies': [
        'error',
        {
          default: 'disallow',
          checkAllOrigins: true,
          policies: [
            { allow: { to: { module: { origin: ['external', 'core'] } } } },
            allow('domain', []),
            allow('application', ['domain']),
            allow('adapters', ['application', 'domain']),
            allow('ds', []),
            {
              from: { element: { type: 'features' } },
              allow: {
                to: {
                  element: {
                    type: ['application', 'domain', 'ds', 'app-services'],
                  },
                },
              },
            },
            {
              from: { element: { type: 'features' } },
              allow: {
                to: {
                  element: {
                    type: 'features',
                    captured: { feature: '{{from.element.captured.feature}}' },
                  },
                },
              },
            },
            allow('app-services', ['application']),
            // Composition root: may import any layer; nothing may import it.
            {
              from: { file: { categories: 'root' } },
              allow: { to: { element: { type: everything } } },
            },
            { disallow: { to: { file: { categories: 'root' } } } },
            {
              from: { element: { type: 'app' } },
              allow: { to: { element: { type: everything } } },
            },
            {
              from: { file: { categories: 'test' } },
              allow: { to: { element: { type: everything } } },
            },
            // Test helpers (src/test/**) are importable by tests and by each other, never by production code.
            {
              from: { file: { categories: 'test' } },
              allow: { to: { file: { categories: 'test' } } },
            },
            {
              from: { element: { type: 'ds' } },
              disallow: { to: { module: { origin: 'external', source: DS_BANNED_MODULES } } },
            },
            {
              from: { element: { type: ['domain', 'application'] } },
              disallow: { to: { module: { origin: 'external', source: FRAMEWORK_MODULES } } },
            },
          ],
        },
      ],
    },
  },
];
