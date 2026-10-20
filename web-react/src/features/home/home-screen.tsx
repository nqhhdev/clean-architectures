import { useTranslation } from 'react-i18next';

import { Heading } from '@/ds/heading';
import { Page } from '@/ds/layout';

export function HomeScreen() {
  const { t } = useTranslation();
  return (
    <Page>
      <Heading>{t('app.title')}</Heading>
    </Page>
  );
}
