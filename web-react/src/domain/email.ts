import { err, ok, type Result } from './result';

export interface Email {
  readonly id: string;
  readonly subject: string;
  readonly sender: string;
  readonly preview: string;
  readonly receivedAt: Date;
  readonly read: boolean;
}

export type EmailInvalid = 'empty_id' | 'invalid_date';

/** The one way to build an `Email`: rejects an empty id and an unparseable date. */
export function createEmail(props: Email): Result<Email, EmailInvalid> {
  if (props.id.trim() === '') return err('empty_id');
  if (Number.isNaN(props.receivedAt.getTime())) return err('invalid_date');
  return ok({ ...props });
}
