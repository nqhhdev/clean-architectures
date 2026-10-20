import type { AppErrorKind } from '@/application/app-error';
import { errorKey } from '@/application/error-key';
import en from '@/locales/en.json';

import { createI18n } from './i18n';

const locales = import.meta.glob<Record<string, unknown>>('../locales/*.json', {
  eager: true,
  import: 'default',
});

function flatten(tree: Record<string, unknown>, prefix = ''): string[] {
  return Object.entries(tree).flatMap(([key, value]) =>
    typeof value === 'object' && value !== null
      ? flatten(value as Record<string, unknown>, `${prefix}${key}.`)
      : [`${prefix}${key}`],
  );
}

describe('locales', () => {
  const expected = flatten(en).sort();

  it.each(Object.entries(locales))('%s has exactly the keys of en.json', (_path, locale) => {
    expect(flatten(locale).sort()).toEqual(expected);
  });

  it('flatten lists nested keys', () => {
    expect(flatten({ a: { b: 'x' }, c: 'y' })).toEqual(['a.b', 'c']);
  });
});

describe('createI18n', () => {
  it('translates synchronously from en.json', () => {
    expect(createI18n().t('nav.home')).toBe('Home');
  });

  it.each<AppErrorKind>(['refused', 'unauthorized', 'network', 'invalid'])(
    'has a message for the %s error kind',
    (kind) => {
      const key = errorKey({ kind });
      expect(createI18n().t(key)).not.toBe(key);
    },
  );
});
