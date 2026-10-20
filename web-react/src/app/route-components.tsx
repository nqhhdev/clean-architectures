import { Link, Outlet, useRouter, type ErrorComponentProps } from '@tanstack/react-router';
import { useEffect } from 'react';
import { useTranslation } from 'react-i18next';

import { errorKey } from '@/application/error-key';
import { QueryError } from '@/application/query-error';
import { Heading } from '@/ds/heading';
import { Inline, Page, Stack } from '@/ds/layout';

import { useServices } from './services/services-context';

export function RootError({ error, reset }: ErrorComponentProps) {
  const router = useRouter();
  const { t } = useTranslation();
  const { crashReporter } = useServices();
  // The router's boundary catches the error, so no global hook sees it: report it here.
  useEffect(() => {
    crashReporter.report(error, { source: 'route.errorComponent' });
  }, [crashReporter, error]);
  return (
    <Page>
      <Stack>
        <div role="alert">
          <Heading>{t('errors.title')}</Heading>
          <p>
            {error instanceof QueryError ? t(errorKey(error.appError)) : t('errors.unexpected')}
          </p>
        </div>
        <button
          type="button"
          onClick={() => {
            reset();
            void router.invalidate();
          }}
        >
          {t('errors.retry')}
        </button>
      </Stack>
    </Page>
  );
}

export function NotFound() {
  const { t } = useTranslation();
  return (
    <Page>
      <Stack>
        <Heading>{t('notFound.title')}</Heading>
        <Link to="/">{t('notFound.back')}</Link>
      </Stack>
    </Page>
  );
}

export function SignInPlaceholder() {
  const { t } = useTranslation();
  return (
    <Page>
      <Heading>{t('signIn.title')}</Heading>
      <p>{t('signIn.unavailable')}</p>
    </Page>
  );
}

export function Shell() {
  const { session } = useServices();
  const { t } = useTranslation();
  return (
    <>
      <header>
        <Inline as="nav">
          <Link to="/">{t('nav.home')}</Link>
          <Link to="/emails">{t('nav.emails')}</Link>
          <button
            type="button"
            onClick={() => {
              void session.signOut();
            }}
          >
            {t('nav.signOut')}
          </button>
        </Inline>
      </header>
      <Outlet />
    </>
  );
}
