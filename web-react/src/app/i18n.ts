import { createInstance, type i18n, type ParseKeys } from 'i18next';

import en from '@/locales/en.json';

// `en.json` is the source of keys (ADR 0015): `t('typo')` is a type error anywhere in the app.
declare module 'i18next' {
  interface CustomTypeOptions {
    defaultNS: 'translation';
    resources: { translation: typeof en };
  }
}

export type TranslationKey = ParseKeys;

/** One instance per app (and per test render): no module-level singleton (ADR 0010). */
export function createI18n(): i18n {
  const instance = createInstance();
  void instance.init({
    lng: 'en',
    fallbackLng: 'en',
    resources: { en: { translation: en } },
    interpolation: { escapeValue: false },
    initAsync: false,
  });
  return instance;
}
