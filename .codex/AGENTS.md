# Project Codex Instructions (Isolated from Claude)

## Scope

- This file is the Codex project source of truth.
- Keep Codex context under `./.codex/` only.
- Do not use `.claude/` files as instruction inputs during normal Codex operation.

## Stack

- Ruby on Rails 8.1, Ruby 3.4, PostgreSQL
- Hotwire (Turbo + Stimulus), ERB, Bootstrap 5, SCSS
- Devise auth
- Minitest + Capybara/Selenium

## Working Rules

- Follow existing Rails conventions and keep controllers thin.
- Prefer readable, incremental changes over broad rewrites.
- Never hardcode secrets.
- Avoid manual lockfile edits; regenerate lockfiles with package tools when needed.

## Commands

- Setup: `bin/setup`
- Run app: `bin/dev`
- Tests: `bin/rails test`
- System tests: `bin/rails test:system`
- Lint: `bin/rubocop`
- Security: `bin/brakeman`, `bin/bundler-audit`, `bin/importmap audit`

## Git

- Use Conventional Commits: `<type>[scope]: <description>`
- No AI co-author trailers
- Keep PRs focused and include verification steps
