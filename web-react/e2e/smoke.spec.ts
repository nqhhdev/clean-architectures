import { expect, test } from '@playwright/test';

test('mock build starts signed in and lists the seeded emails', async ({ page }) => {
  await page.goto('/');
  await expect(page.getByRole('heading', { name: 'web-react' })).toBeVisible();

  await page.getByRole('link', { name: 'Emails' }).click();

  await expect(page).toHaveURL(/\/emails$/);
  await expect(page.getByRole('heading', { name: 'Emails' })).toBeVisible();
  await expect(page.getByText('Welcome to web-react (Unread)')).toBeVisible();
  await expect(page.getByText('Your weekly summary')).toBeVisible();
});
