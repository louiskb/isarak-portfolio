# Isarak Portfolio — TODO

> Created: 2026-03-08 | Last updated: 2026-03-12 (featured_image, inline images, keep-image checkbox, ENV.fetch)
> Both Louis and Claude maintain this file. Check it at the start of each session.

## Current Focus
Phase 3 — Blog (pair programming, Louis leads)

---

## Phase 1 — Project Setup
- [x] Bootstrap color scheme (teal, grey, white)
- [x] Google Fonts (Playfair Display + Inter)
- [x] CLAUDE.md, README.md
- [ ] Confirm .gitignore covers `.env`, `.mcp.json` tokens, `settings.local.json`
- [x] Navbar
- [x] Footer
- [x] Add footer render to application layout

---

## Phase 2 — Backend (Models & Admin Management)
- [x] Identify all resource types — ResearchItem, GrantAward, Teaching, BlogPost
- [x] Scaffold + migrate all 4 models
- [x] FriendlyId slugs on all resources
- [x] Enums — ResearchItem (project/paper/publication), GrantAward (grant/award), BlogPost (draft/scheduled/published)
- [x] belongs_to :user on all resources + has_many on User with dependent: :destroy
- [x] Auth gates — authenticate_user! on all controllers (BlogPost index/show public)
- [x] CV attachment on User (has_one_attached :cv)
- [ ] Cloudinary wiring — configure Active Storage to use Cloudinary as backend (all uploads: CV, images, Trix)
- [ ] Admin management views — restyle scaffold views to match dark theme
- [ ] Seed data for development
- [x] Contact form — model, controller, mailer, routes, invisible_captcha spam protection, load-button Stimulus controller, form partial wired to homepage
  - [ ] Configure SMTP provider + fill in ENV vars when deploying (MAILER_SENDER, SMTP_ADDRESS, SMTP_PORT, SMTP_DOMAIN, SMTP_USERNAME, SMTP_PASSWORD)
  - [ ] Enable dev email delivery — uncomment Letter Opener or local SMTP block in development.rb
  - [ ] Update production.rb `action_mailer.default_url_options` host to real domain

---

## Phase 3 — Blog + AI Blog Builder
- [x] BlogPost model — title, author, status enum, ai_generated, scheduled_at, slug, blog_post_erb_content
- [x] Action Text — has_rich_text :body (optional rich text editor)
- [x] has_many_attached :photos on BlogPost (Active Storage → Cloudinary)
- [x] FriendlyId slug on BlogPost
- [x] Strong params wired (body, blog_post_erb_content, photos, all fields)
- [x] Model guard — one_content_field_only validation (body OR blog_post_erb_content, never both)
- [x] Blog post form (_form.html.erb) — mode-aware: Trix for manual, HTML textarea for AI posts
- [x] Public blog show view — sanitize + html-inject Stimulus controller for AI content; body for rich text
- [x] AI blog post generator (RubyLLM) — BlogPostAiService + BlogPostSchema
  - [x] create_from_prompt — creates new post from natural language prompt
  - [x] revise_blog_post — revises existing post; clears body if transitioning from manual
  - [x] Warning modal on manual→AI transition (edit + show pages)
  - [x] ai_new + ai_revise views with load-button Stimulus spinner
  - [x] Unsplash integration — auto feature image prepended with photographer attribution
  - [x] sanitize initializer — figure, figcaption, style added to allowlist
  - [x] Inline Unsplash images — AI puts `<!-- IMAGE: query -->` placeholders; service replaces with real Unsplash figures
- [x] featured_image on BlogPost — `has_one_attached :featured_image`; shown on show page; upload on all forms (manual + AI new + AI revise); on AI revision defaults to fresh Unsplash; "Keep this image" checkbox on ai_revise to opt out; ENV.fetch used project-wide
- [ ] Show featured_image on public blog index cards (once index view is built)
- [x] Add UNSPLASH_ACCESS_KEY to .env — done (access key only; secret key not needed)
- [ ] Public blog index view
- [ ] Scheduled posts via Solid Queue background jobs
- [ ] Pagination on blog index (Pagy)

---

## Phase 4 — Landing Page
- [ ] Build from Figma: https://www.figma.com/design/urlKYDQaoyIghxaQg69bYC/isarak-portfolio
- [ ] Hero section
- [ ] About / bio section
- [ ] Resource sections (ResearchItem, GrantAward, Teaching) — dynamically populated
- [x] Contact form section — backend done, form partial rendered at bottom of homepage
  - [ ] Restyle contact section to match Figma design (Phase 4 visual pass)
- [ ] Animations / scroll effects
- [ ] Mobile responsive check

---

## Ideas & Future Considerations
- Animate landing page sections on scroll (AOS, GSAP, or CSS transitions)
- High-quality AI-generated imagery (Louis has access to generators)
- Dark mode toggle
- RSS feed for blog

---

## Decisions Made
- Auth: Devise, single user (Isara only — no public sign-up)
- Styling: Bootstrap 5.3 + SCSS (no Tailwind)
- Font: Playfair Display (headings) + Inter (body)
- Colors: Dark theme — Teal `#89D6CC`, Charcoal `#2D2D2D`, Black `#080808`
- URL slugs: FriendlyId on all resources
- Background jobs: Solid Queue (Rails 8 default)
- All uploads → Cloudinary via Active Storage backend (not local disk)
- Blog content: dual-mode — Action Text `body` (manual) OR `blog_post_erb_content` (AI-generated HTML/ERB)
- AI-generated posts set `ai_generated: true` flag automatically
- ENV vars: prefer `ENV.fetch("KEY", nil)` over `ENV["KEY"]` in all app code (not Rails/system boilerplate)
- Build order: Setup → Navbar/Footer → Backend → Blog → Landing Page

## Questions / Open Items
- Will Isara need multiple language support (EN/TH)?
- Hosting / deployment plan (Heroku, Railway, Kamal?)
- Does Isara want an RSS feed for the blog?
- Teaching model: use `has_one_attached :image` (Active Storage → Cloudinary) or plain `image_url` string? — decide when implementing uploads
