# CLAUDE.md — isarak-portfolio

## What This App Is
Professional portfolio and blog for **Dr Isara Khanjanasthiti**, academic at the University of New England (UNE), Sydney campus. Built by Louis Bourne (client work, free — for a friend). Single authenticated user (Isara); public visitors browse research, publications, and blog.

## Reference Repo
Louis's own portfolio (same structure, use as reference):
- **Repo**: https://github.com/louiskb/louis-porfolio

## Figma
- https://www.figma.com/design/urlKYDQaoyIghxaQg69bYC/isarak-portfolio
- Contains: Landing Page, Blog Page, Portfolio Page (desktop + mobile)

## Tech Stack
- **Rails 8.1** with PostgreSQL, **Importmap** (no Node/Webpack)
- **Bootstrap 5.3** + SCSS (dark theme)
- **Devise** for authentication (Isara is the only user)
- **simple_form** — use `simple_form_for` for all forms
- **FriendlyId** for readable URLs on all public-facing resources
- **Cloudinary** for image uploads (Active Storage adapter)
- **Pagy** for pagination
- **RubyLLM** for AI blog post generation
- **Solid Queue** for background jobs (scheduled posts)
- **Action Text** (Trix rich text editor for blog posts)
- **Hotwire** (Turbo + Stimulus) for SPA-like interactions
- **invisible_captcha** — honeypot spam protection on contact form
- **PostHog** — cookieless visitor analytics (`posthog-ruby` + `posthog-rails` server-side, `posthog-js` client-side inline snippet; `persistence: 'memory'`, no cookies)
- **Minitest** for testing (Rails default)

## Color Scheme (Dark Theme — GMK Delta Light)
- **Primary**: Teal `#89D6CC`
- **Surface**: Charcoal `#2D2D2D`
- **Page bg**: Black `#080808`
- **Text**: Light gray `#E2E2E2`
- **Borders**: `#3D3D3D`

## Typography (Google Fonts)
- **Headings**: Playfair Display (serif)
- **Body**: Inter (sans-serif)

## Commands
```bash
rails server              # Start dev server
rails console             # Rails console
rails db:migrate          # Run migrations
rails db:seed             # Seed admin user + sample data
rails test                # Run all Minitest tests
bundle install            # Install gems
bundle exec rubocop -a    # Auto-fix linting
```

## Architecture
```
app/
  controllers/        # RESTful controllers + pages_controller (home)
    users/            # Custom Devise sessions controller (empty override)
  javascript/
    controllers/      # Stimulus controllers (analytics, load_button, html_inject, sortable, char_counter, etc.)
  models/             # BlogPost, Teaching, ResearchItem, GrantAward, Contact, Tag, User, Service
  schemas/            # RubyLLM structured output schemas (blog_post_schema.rb)
  services/           # BlogPostAiService (AI generation + Unsplash)
  views/
    blog_posts/       # Blog CRUD + AI new/revise views
    pages/            # Landing page (home.html.erb) + partials (_hero, _about, _contact, etc.)
    shared/           # _navbar, _footer, _flashes
config/
  importmap.rb        # JS dependencies (Turbo, Stimulus, Bootstrap, SortableJS)
vendor/javascript/    # Vendored ESM builds (sortablejs.js)
```

## Key Files
- `app/services/blog_post_ai_service.rb` — AI blog creation + revision with Unsplash images
- `app/assets/stylesheets/_colors.scss` — All theme color variables
- `app/assets/stylesheets/_bootstrap_variables.scss` — Bootstrap overrides
- `config/importmap.rb` — JavaScript pin configuration
- `config/initializers/posthog.rb` — PostHog server-side config (auto-instrumentation, exception capture, ActiveJob)

## Environment Variables
Required in `.env`:
- `CLOUDINARY_URL` — Cloudinary connection string
- `OPENAI_API_KEY` — AI blog generation (production)
- `UNSPLASH_ACCESS_KEY` — Blog post image sourcing
- `USER_EMAIL`, `USER_PASSWORD`, `USER_NAME` — Admin seed credentials
- `MAILER_SENDER` — Email sender address
- `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_DOMAIN`, `SMTP_USERNAME`, `SMTP_PASSWORD` — SMTP config
- `APP_HOST` — Application host for mailer URLs
- `POSTHOG_PROJECT_TOKEN` — PostHog project API key
- `POSTHOG_HOST` — PostHog ingest endpoint (e.g. `https://us.i.posthog.com`)

## Conventions
- Double quotes throughout (Ruby, ERB, JS, HTML attributes)
- 2-space indentation
- Conventional commits (`feat:`, `fix:`, `chore:`, etc.)
- RuboCop enforced via `.rubocop.yml` (inherits rubocop-rails-omakase)
- All public-facing resources use FriendlyId slugs
- `simple_form_for` for all forms (never `form_with`/`form_for`)

## Gotchas
- **Bootstrap UMD + importmap** — `import { Modal } from "bootstrap"` fails silently. Always use `window.bootstrap?.Modal` in Stimulus controllers.
- **Pagy v9 API** — `@pagy.bootstrap_series_nav` is protected. Use `@pagy.series_nav(:bootstrap)`.
- **Bootstrap `.d-flex` vs `display:none`** — `.d-flex` has `!important`. Use `classList.add("d-none")` to hide, not `style.display = "none"`.
- **`button_to` inside forms** — Creates nested `<form>` tags (invalid HTML). Use `link_to` with `data-turbo-method` instead.
- **Page fade-in animation + modals** — CSS `transform` on `<main>` traps modal z-index. Fix: set `animation: none` on `animationend`.
- **Cloudinary `.env` inline comments** — dotenv includes comments in value → `URI::InvalidURIError`. Put comments on their own line.
- **Active Storage `purge` with Cloudinary** — If Cloudinary raises, transaction rolls back. Use `detach` + `blob.purge_later` instead.
- **SortableJS** — Must use ESM build (`sortable.esm.js`), not UMD. Vendored in `vendor/javascript/`.
- **App timezone** — Set to `"Sydney"` — affects how `datetime-local` inputs are parsed.

## Important Notes
- Isara is the **only authenticated user** — no public sign-up
- Blog dual-mode: Action Text `body` (manual) OR `blog_post_erb_content` (AI-generated HTML)
- AI-generated posts set `ai_generated: true` automatically
- Teaching, Research, and Grant Awards all have public index + show pages; visitors see published items only
- `card_summary` column on Research, Teaching, and Grant Awards — short text shown on index/homepage cards; `description` is the full content shown on show pages only (parallels `blog_excerpt` on BlogPost)
- Drag-and-drop reordering on index pages (SortableJS + `position` column)
- Contact form uses Turbo disabled (`data-turbo="false"`) for reliable flash rendering
- CV is an Active Storage attachment on User model (not its own model)
- PostHog is **cookieless** (`persistence: 'memory'`) — no cookies, no localStorage, no cross-session tracking. JS snippet only loads for visitors (not admin). No cookie banner needed.
- PostHog **server-side events** (controllers): `blog_post_viewed`, `research_item_viewed`, `teaching_viewed`, `contact_submitted`, `cv_downloaded`
- PostHog **client-side events** (Stimulus): `cta_clicked`, `nav_link_clicked`, `footer_link_clicked`, `social_link_clicked`, `blog_card_clicked`, `blog_searched`, `blog_tag_filtered`, `blog_tag_clicked`, `blog_read_progress`, `blog_link_copied`, `research_card_clicked`, `related_post_clicked`, `teaching_spotlight_navigated`, `awards_slider_navigated`
- `analytics_controller.js` — generic Stimulus controller for declarative event tracking via `data-action` attributes
- No admin events tracked (no login, no blog create/publish/AI events)
