import { useSuspenseQuery } from '@tanstack/react-query';
import { useTranslation } from 'react-i18next';

import { useServices } from '@/app/services/services-context';
import { Heading } from '@/ds/heading';
import { Page, Stack } from '@/ds/layout';

import styles from './emails-screen.module.css';
import { emailsQueryOptions } from './queries';

export function EmailsScreen() {
  const { t, i18n } = useTranslation();
  const { data: emails } = useSuspenseQuery(emailsQueryOptions(useServices()));
  const date = new Intl.DateTimeFormat(i18n.language, { dateStyle: 'medium', timeStyle: 'short' });

  return (
    <Page>
      <Stack>
        <Heading>{t('emails.title')}</Heading>
        {emails.length === 0 ? (
          <p>{t('emails.empty')}</p>
        ) : (
          <Stack as="ul" gap={2}>
            {emails.map((email) => (
              <li key={email.id} className={styles.item}>
                <strong>{email.sender}</strong>
                <span>
                  {email.read ? email.subject : `${email.subject} (${t('emails.unread')})`}
                </span>
                <span>{email.preview}</span>
                <time dateTime={email.receivedAt.toISOString()}>
                  {date.format(email.receivedAt)}
                </time>
              </li>
            ))}
          </Stack>
        )}
      </Stack>
    </Page>
  );
}
