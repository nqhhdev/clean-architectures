import js from '@eslint/js';
import query from '@tanstack/eslint-plugin-query';
import vitest from '@vitest/eslint-plugin';
import reactHooks from 'eslint-plugin-react-hooks';
import globals from 'globals';
import tseslint from 'typescript-eslint';

import boundaries from './eslint.boundaries.config.js';
import security from './eslint.security.config.js';

export default tseslint.config(
  {
    ignores: [
      'dist',
      'dist-mock',
      'coverage',
      'test-results',
      'playwright-report',
      'public',
      'public-mock',
      'src/adapters/api/generated',
    ],
  },
  js.configs.recommended,
  ...tseslint.configs.strictTypeChecked,
  ...tseslint.configs.stylisticTypeChecked,
  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      globals: globals.browser,
      parserOptions: { projectService: true, tsconfigRootDir: import.meta.dirname },
    },
    plugins: { 'react-hooks': reactHooks },
    rules: {
      ...reactHooks.configs.recommended.rules,
      // TanStack Router guards throw `redirect()` / `notFound()` objects by design (ADR 0013).
      '@typescript-eslint/only-throw-error': [
        'error',
        { allow: [{ from: 'package', package: '@tanstack/router-core', name: 'Redirect' }] },
      ],
    },
  },
  ...query.configs['flat/recommended'],
  { files: ['**/*.test.{ts,tsx}'], ...vitest.configs.recommended },
  ...boundaries,
  ...security,
  {
    // Node scripts outside `src/` and the tsconfig: no type information, no boundary elements.
    files: ['*.config.{js,ts}', 'scripts/**/*.mjs', 'docker/**/*.mjs'],
    ...tseslint.configs.disableTypeChecked,
    languageOptions: {
      ...tseslint.configs.disableTypeChecked.languageOptions,
      globals: globals.node,
    },
  },
);
