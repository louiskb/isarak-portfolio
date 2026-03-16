# Project Memory

## Contact Form

- Codex implemented and verified the contact form flow in March 2026.
- The contact form now submits as a normal HTML request with Turbo disabled on that form so flash messages render reliably.
- Invisible Captcha remains enabled; live and test submissions must include the generated spinner value and wait past the timestamp threshold.
- Validation failures re-render the homepage contact section with inline errors instead of redirecting away.
- Email delivery failures are rescued in the controller, shown to the user as a visible alert, and do not leave behind a persisted `Contact` record.
- The admin notification email now shows the contact sender's name in the `From` label as `"Sender Name via Dr Isara Khanjanasthiti" <MAILER_SENDER>` while keeping `reply_to` pointed at the contact sender.
- The confirmation email no longer uses BCC; it sends from `MAILER_SENDER` directly to the contact so the contact can reply back to the site owner normally.
- Contact controller tests now include a regression case proving `invisible_captcha` blocks a bad `spinner` submission without creating a `Contact` or sending email.

## Mailer Setup

- Development uses SMTP when `SMTP_ADDRESS`, `SMTP_USERNAME`, and `SMTP_PASSWORD` are present; otherwise it falls back to writing mail files to `tmp/mails`.
- Development includes a local SSL workaround via `openssl_verify_mode`; this is for local debugging only.
- Production must keep normal SSL certificate verification enabled and must not copy the development `openssl_verify_mode: "none"` workaround.
- Expected production env vars: `MAILER_SENDER`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_DOMAIN=icloud.com`, and `APP_HOST`.
