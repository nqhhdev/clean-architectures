The Emails sample slice: model, errors and how the layers carry them.

# Concepts
* [Email](email.md) - A message in the list: id, subject, sender, preview, receivedAt (Date) and read; built only with createEmail.
* [Email errors](email-errors.md) - EmailInvalid (empty_id, invalid_date) from createEmail, and how the adapter maps it to an invalid AppError.
* [Emails](emails.md) - The sample slice: list emails newest first from GET /emails, across domain, port, adapter, query and screen.
