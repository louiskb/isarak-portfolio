# Claude Project Memory

## Contact Form Update

- Codex implemented the contact-form fixes in March 2026, not Claude.
- Codex changed the form to submit as normal HTML with Turbo disabled for that form so notices and alerts show reliably.
- Codex fixed the controller flow so validation errors re-render the homepage form with inline errors and email-delivery failures show a visible alert.
- Codex wrapped contact save + email delivery so failed delivery does not leave behind a persisted `Contact` record or re-render the form as an edit form.
- Codex updated the admin notification email so the inbox sender label shows the contact person's name as `"Sender Name via Dr Isara Khanjanasthiti" <MAILER_SENDER>` while replies still go to the contact sender.
- Codex removed the earlier confirmation-email BCC approach; the confirmation email now just sends from `MAILER_SENDER` to the contact, so the contact can reply directly to the site owner.
- Codex added a regression test proving the contact form's `invisible_captcha` spam protection blocks an invalid `spinner` submission without creating a `Contact` or sending email.

## Mailer Configuration Notes

- Development may use a local SSL workaround for SMTP certificate issues.
- Production should keep normal SSL certificate verification enabled and should not use the development `openssl_verify_mode: "none"` workaround.
- Production mailer env vars expected by the app are `MAILER_SENDER`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_DOMAIN=icloud.com`, and `APP_HOST`.
