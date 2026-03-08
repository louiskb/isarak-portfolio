# Isarak Portfolio — TODO

> Created: 2026-03-08 | Last updated: 2026-03-08
> Both Louis and Claude maintain this file. Check it at the start of each session.

## Current Focus
Navbar + footer

---

## Phase 1 — Project Setup
- [x] Bootstrap color scheme (teal, grey, white)
- [x] Google Fonts (Playfair Display + Inter)
- [x] CLAUDE.md, README.md
- [ ] Confirm .gitignore covers `.env`, `.mcp.json` tokens, `settings.local.json`
- [ ] Navbar
- [ ] Footer
- [ ] Add footer render to application layout

---

## Phase 2 — Backend (Models & Admin Management)
- [ ] Identify all resource types (research papers, publications, talks, awards, etc.) — confirm with Isara
- [ ] Generate models, migrations, controllers for each resource type
- [ ] FriendlyId slugs on all public-facing resources
- [ ] Seed data for development
- [ ] Admin dashboard / management views (CRUD) — login-gated
- [ ] Document upload/download (CV, research papers) via Cloudinary or Active Storage
- [ ] Contact form (Action Mailer)

---

## Phase 3 — Blog + AI Blog Builder
- [ ] Blog post model (title, body via Action Text, published_at, status: draft/scheduled/published)
- [ ] Rich text editor (Action Text) + image upload (Cloudinary)
- [ ] FriendlyId slugs on posts
- [ ] Scheduled posts via Solid Queue background jobs
- [ ] AI blog post generator (RubyLLM)
- [ ] AI-generated posts can be scheduled too
- [ ] Public blog index + show pages
- [ ] Pagination (Pagy)

---

## Phase 4 — Landing Page
- [ ] Build from Figma: https://www.figma.com/design/urlKYDQaoyIghxaQg69bYC/isarak-portfolio
- [ ] Hero section
- [ ] About / bio section
- [ ] Resource sections (research, publications, etc.) — dynamically populated from Phase 2 models
- [ ] Contact form section
- [ ] Animations / scroll effects (to discuss — Louis has design inspirations)
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
- Colors: Teal `#0D9488`, Dark gray `#1F2937`, White `#FFFFFF`
- URL slugs: FriendlyId on all public resources
- Background jobs: Solid Queue (already included in Rails 8 stack)
- Build order: Setup → Navbar/Footer → Backend → Blog → Landing Page

## Questions / Open Items
- Confirm resource types with Isara (research papers? publications? conference talks? awards?)
- Will Isara need multiple language support (EN/TH)?
- Hosting / deployment plan (Heroku, Railway, Kamal?)
- Does Isara want an RSS feed for the blog?
