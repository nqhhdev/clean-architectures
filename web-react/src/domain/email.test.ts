import { createEmail, type Email } from './email';

const props: Email = {
  id: 'e1',
  subject: 'Hello',
  sender: 'a@example.com',
  preview: 'Hi there',
  receivedAt: new Date('2026-10-19T08:00:00Z'),
  read: false,
};

describe('createEmail', () => {
  it('returns the email for valid props', () => {
    expect(createEmail(props)).toEqual({ ok: true, value: props });
  });

  it('rejects an empty id', () => {
    expect(createEmail({ ...props, id: '  ' })).toEqual({ ok: false, error: 'empty_id' });
  });

  it('rejects an invalid date', () => {
    expect(createEmail({ ...props, receivedAt: new Date('nope') })).toEqual({
      ok: false,
      error: 'invalid_date',
    });
  });
});
