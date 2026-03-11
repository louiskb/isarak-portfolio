# Isarak Portfolio — TODO

> Created: 2026-03-08 | Last updated: 2026-03-11
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
- [ ] Contact form (Action Mailer)

---

## Phase 3 — Blog + AI Blog Builder
- [x] BlogPost model — title, author, status enum, ai_generated, scheduled_at, slug, blog_post_erb_content
- [x] Action Text — has_rich_text :body (optional rich text editor)
- [x] FriendlyId slug on BlogPost
- [x] Strong params wired (body, blog_post_erb_content, all fields)
- [ ] Blog post form (new/edit) — Louis building
- [ ] Public blog index view
- [ ] Public blog show view — render body OR blog_post_erb_content depending on which is set
- [ ] Scheduled posts via Solid Queue background jobs
- [ ] AI blog post generator (RubyLLM) — sets ai_generated: true, populates blog_post_erb_content
- [ ] Pagination on blog index (Pagy)

---

## Phase 4 — Landing Page
- [ ] Build from Figma: https://www.figma.com/design/urlKYDQaoyIghxaQg69bYC/isarak-portfolio
- [ ] Hero section
- [ ] About / bio section
- [ ] Resource sections (ResearchItem, GrantAward, Teaching) — dynamically populated
- [ ] Contact form section (including backend logic)
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
- Build order: Setup → Navbar/Footer → Backend → Blog → Landing Page

## Questions / Open Items
- Will Isara need multiple language support (EN/TH)?
- Hosting / deployment plan (Heroku, Railway, Kamal?)
- Does Isara want an RSS feed for the blog?
- Teaching model: use `has_one_attached :image` (Active Storage → Cloudinary) or plain `image_url` string? — decide when implementing uploads
