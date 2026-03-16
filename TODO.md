# Isarak Portfolio — TODO

> Created: 2026-03-08 | Last updated: 2026-03-17 (session 13: README rewrite — correct university, full setup guide, env vars, gotchas)
> Both Louis and Claude maintain this file. Check it at the start of each session.

## Current Focus
Phase 4 complete ✅ — Landing page live with animations. Mobile optimisation audit complete. Next: About section + working down the portfolio page sections. Real content from Isara needed.

---

## Phase 1 — Project Setup
- [x] Bootstrap color scheme (teal, grey, white)
- [x] Google Fonts (Playfair Display + Inter)
- [x] CLAUDE.md, README.md
- [x] Confirm .gitignore covers `.env`, `.mcp.json` tokens, `settings.local.json` — `.env*` double-covered; `.mcp.json` has no tokens (safe to commit); `.claude/settings.local.json` added ✅ (2026-03-15)
- [x] Navbar
  - [x] Logo moved to left side
  - [x] Blog dropdown (signed-in) — All Posts / New Post / Create with AI
  - [x] Avatar dropdown (signed-in) — Profile / Logout
  - [x] Bootstrap JS loading fixed — `pin "bootstrap"` + `pin "@popperjs/core"` added to importmap.rb
  - [x] Reordered: Home | Teaching | Research | Service | Awards | Blog ✅ (2026-03-14)
  - [x] Visitor nav — Teaching + Awards link to homepage anchor sections (#teaching, #awards) ✅
  - [x] Service page — static route + PagesController action + placeholder view ✅
  - [x] Sticky navbar — `position: sticky` on `<header>` ✅ (2026-03-15)
  - [x] Homepage scroll effect — frosted glass before 30% scroll, dark pill after; iron-wall rule prevents bleed to other pages ✅ (2026-03-15)
  - [x] Contact Me navbar link — fixed to use `root_path(anchor: "contact")` so it navigates to homepage first (was `#contact`, only worked on the homepage itself) ✅ (2026-03-17)
  - [x] Mobile burger menu polish — no border/grey box, pill on scroll, 5px radius, safe padding ✅ (2026-03-15)
  - [x] Social links added to hero banner (8 links: LinkedIn, ORCID, ResearchGate, Academia, Scholar, X, UNE, Email) ✅ (2026-03-15)
- [x] Footer
  - [x] Social links added (same 8) ✅ (2026-03-15)
  - [x] Layout fixed — links left, copyright center, socials right ✅ (2026-03-15)
  - [x] Font consistency — all footer text unified at `0.8rem`; social icons restored to `1rem`; font-size set on `.site-footer` so all children inherit ✅ (2026-03-17)
  - [x] Login link font size matches Privacy Policy + Terms of Service links (`font-size: inherit` on `.footer-legal a`) ✅ (2026-03-17)
  - [x] Privacy Policy + Terms of Service pages — `.legal-hero` + `.legal-body` layout; `_legal.scss` styles; routes + PagesController actions; linked from footer ✅ (2026-03-17)
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
  - [x] CV download filename — `fl_attachment:isara_khanjanasthiti_cv` via URL sub in `download_cv` action ✅ (2026-03-17)
  - [x] CV delete button on profile page — `link_to` with `data-turbo-method: :delete`; `detach` + `blob.purge_later` for immediate UI update; `link_spinner_controller.js` shows hourglass after confirm ✅ (2026-03-17)
  - [ ] CV page-1 preview — use Cloudinary's PDF-to-image transformation to show a thumbnail of page 1 of Isara's CV (e.g. on landing page or a dedicated CV section)
- [x] Cloudinary wiring — verified: Active Storage uses Cloudinary in dev + prod; handles images, PDFs, Trix uploads; no initializer needed (gem auto-reads CLOUDINARY_URL)
- [x] ERD (docs/ERD.md) — updated to match schema: Contact model added, user_id FKs on all resource tables, User Devise fields corrected, BlogPost featured_image + photos relationships documented
- [x] Admin management views — restyle scaffold views to match dark theme
- [x] Seed data for development — 6 teachings, 8 research, 8 grants/awards, 6 blog posts, 1 service; seeds have descriptive puts output ✅ (2026-03-15)
- [x] Contact form — model, controller, mailer, routes, invisible_captcha spam protection, load-button Stimulus controller, form partial wired to homepage
  - [x] Configure iCloud SMTP — `smtp.mail.me.com`, port 587, `authentication: :login`, ENV vars wired ✅ (2026-03-15)
  - [x] Contact form refactored by Codex ✅ (2026-03-16) — controller uses transaction so failed delivery never persists a Contact; validation errors re-render homepage with inline errors; HomePageContent concern extracted; admin email uses "Sender via Dr Isara" label with reply-to; dev SMTP auto-configured from ENV vars with file fallback; regression tests added
  - [x] Contact form spinner fix ✅ (2026-03-16) — button wrapped in `buttons` target div; `type="button"` + `load-button#loader` so spinner correctly replaces button with matching `btn-grad` style
  - [ ] Set `SMTP_PASSWORD` to Apple app-specific password in `.env` (generate at appleid.apple.com → App-Specific Passwords)
  - [ ] Set `APP_HOST` to real domain in `.env` before deploying
- [x] Devise mailer wired to SMTP ✅ (2026-03-16) — `config.mailer_sender` set to `MAILER_SENDER` ENV var; shares iCloud SMTP config with contact mailer
- [x] Devise `:confirmable` added ✅ (2026-03-16) — email change verification; migration adds 4 columns + index; existing user auto-confirmed; `reconfirmable: true` already set
- [x] `send_email_changed_notification` + `send_password_change_notification` enabled ✅ (2026-03-16)
- [x] Load-button spinners on all Devise views ✅ (2026-03-16) — sessions, passwords (new + edit), registrations (new + edit), confirmations, unlocks; profile page already had it

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
- [x] Show featured_image on public blog index cards ✅
- [x] image_url fallback on BlogPost — migration, strong params, all 3 forms (manual + ai_new + ai_revise), all 3 views (show + index + home), seeds ✅ (2026-03-15)
- [x] Live image preview Stimulus controller (`image_preview_controller.js`) — `connect()` auto-shows on page load; `updateUrl` for URL field; `updateFile` for uploads; wired to all blog forms ✅ (2026-03-15)
- [x] Bug fix — `image_url` wasn't being saved on AI create/revise (ai_params had it but controller never forwarded it to the service; service never set it on the record) ✅ (2026-03-15)
- [x] Bug fix — duplicate URL preview on manual edit form (`_form.html.erb`) — static server-rendered preview + Stimulus preview both showed; removed static one ✅ (2026-03-15)
- [x] Add UNSPLASH_ACCESS_KEY to .env — done (access key only; secret key not needed)
- [x] Public blog index view ✅
- [x] Scheduled posts via Solid Queue background jobs
  - [x] PublishScheduledPostsJob — finds scheduled posts past scheduled_at, calls published!
  - [x] recurring.yml — job runs every minute in development + production
  - [x] bin/dev + Procfile.dev — foreman starts Rails server + Solid Queue worker together (rails server alone does NOT start the worker)
  - [x] database.yml — development queue database added (isarak_portfolio_development_queue)
  - [x] development.rb — Solid Queue adapter + connects_to :queue configured
  - [x] db:schema:load required on fresh clone to set up queue_schema.rb (secondary DB)
  - [x] App timezone set to "Sydney" ✅ (2026-03-17) — was defaulting to UTC, causing scheduled times to be 11hrs off for Isara in Sydney; `config.time_zone = "Sydney"` in application.rb
- [x] Blog post status management (show page — Isara only)
  - [x] Status badge (green=published, yellow=scheduled, grey=draft) — Isara only
  - [x] Publish now button — draft posts (turbo confirm)
  - [x] Schedule modal — draft posts only; datetime-local picker
  - [x] Publish now modal — scheduled posts; warns schedule will be cancelled
  - [x] Edit scheduled post modal — update scheduled_at or revert to draft
  - [x] cancel_schedule action — sets status: draft, clears scheduled_at
  - [x] Show status badge on public blog index cards (Isara only) ✅
- [x] Publish/schedule edge cases — consistent `resolve_publish_intent` across all 4 save actions; `publish_notice` flash helper; split-button dropup on all create/edit forms (manual + AI) ✅
- [x] Pagination — Pagy wired on all 4 resource indexes (blog_posts, research_items, teachings, grant_awards); limit=9 globally ✅
- [x] Container layout — all new/edit/form views wrapped in `container py-5 > row justify-content-center > col-lg-8` ✅
- [x] Author hardcoded on BlogPost — `before_validation :set_author` always sets "Isara Khanjanasthiti"; removed from forms; "By [author]" shown on show page above meta row ✅
- [x] Blog edit form — status indicator for all 3 statuses (draft / scheduled / published) with contextual message + "use the dropdown" nudge ✅
- [x] Fixed form submission bug — Bootstrap UMD bundle incompatible with ESM named imports; Stimulus controller was crashing silently on `import { Modal } from "bootstrap"`; fix: removed import, use `window.bootstrap?.Modal` inline ✅
- [x] Fixed Bootstrap modal stacking context ✅ (2026-03-16) — `page-fade-in` transform animation permanently promoted `<main>` to a GPU compositing layer in Chrome, trapping modals below the backdrop; fix: `animationend` on `<main>` sets `animation: none` to force layer demotion; `turbo:before-cache` cleans the inline style; `turbo:before-render` removes leftover backdrop/modal-open state
- [x] Fixed double flash on new post save — show.html.erb had a duplicate `render "shared/flashes"`; removed (layout already renders it globally) ✅
- [x] Fixed Pagy v9 API — `@pagy.series_nav(:bootstrap)` replaces `@pagy.bootstrap_series_nav` (now protected in Pagy v43+); updated all 4 index views ✅
- [x] Blog index status badge — moved from image overlay (position-absolute) to card body above date row; more visible and less design noise ✅
- [x] Blog index cards — status badge + AI label in same row (gap-3); scheduled date shows full datetime e.g. `Scheduled 17 Mar 2026 at 10:09` ✅ (2026-03-17)
- [x] Pagination spacing — wrapped pagination in `div.mt-4` on all 4 index views so it doesn't stick to the cards ✅
- [x] Pagination disabled state — `$pagination-disabled-bg/color/border-color` overridden in `_bootstrap_variables.scss`; Bootstrap default used `$white` bg (invisible chevron on dark theme); now stays charcoal with dimmed text ✅
- [x] Pagination active click state — `.pagination .page-link:active { color: $black }` in `_resources.scss` prevents white chevron during click flash ✅
- [x] Copy link button on blog post show page — `copy_link_controller.js` Stimulus controller; `fa-link` icon in meta row (`ms-auto` right-aligned); copies `window.location.href` to clipboard; icon swaps to `fa-check` for 2s as confirmation ✅ (2026-03-17)

---

## Phase 4 — Landing Page
- [x] Build from Figma: https://www.figma.com/design/urlKYDQaoyIghxaQg69bYC/isarak-portfolio
- [x] Hero section — name, eyebrow labels, circular photo (avatar or pug placeholder), Contact Me (primary) + View Research (outline)
- [x] About / bio section — `User.about` bio with placeholder fallback, research interest tags, Download CV (if attached), facts sidebar
- [x] Resource sections — Featured Research (3-col), Teaching (4-col, view-all auth-gated), Grants & Awards (4-col, view-all auth-gated), Blog Posts (3-col cards with images)
- [x] Contact form section — restyled to match dark theme, Bootstrap card wrapper removed
- [x] Teaching & Grants "View all →" links — hidden from public visitors; only shown to signed-in Isara
- [x] Favicon — IK monogram (dark bg, teal text) replacing default Rails icon; swap when Isara has a real logo
- [x] CV Download button — RESOLVED ✅ (2026-03-14); Cloudinary PDF delivery enabled + `fl_attachment` redirect
- [ ] Get Isara's real content in (bio, avatar, CV, featured items marked)
- [x] Mobile responsive check — full audit done (critical/medium/low all fixed) ✅ (2026-03-15)
- [x] Hero entrance animations — navbar slides down, name/subtitle fade in together, CTAs slide up, socials stagger left-to-right, tags stagger right-to-left, chevron last; all use ease-out for smooth cinematic feel ✅ (2026-03-14)
- [x] Back-to-top chevron button — fixed bottom-right, appears at 25% scroll, clears footer on mobile, safe-area inset aware ✅ (2026-03-15)
- [x] btn-grad border — subtle white border on all gradient buttons (Contact Me, Send Message) ✅ (2026-03-15)
- [ ] Scroll-triggered animations for below-fold sections (AOS or CSS)
- [x] About section — wire up real content, photo, bio, research interest tags, CV download
- [x] Resource sections — Featured Research, Teaching, Grants & Awards, Blog posts (review layout + content)
- [x] Research cards — `g-3` → `g-4` gutter spacing; `#3D3D3D` solid border ✅ (2026-03-16)
- [x] Teaching image panels — `#3D3D3D` solid border on `.teaching-spotlight-image-panel` ✅ (2026-03-16)

---

## Ideas & Future Considerations
- Animate landing page sections on scroll (AOS, GSAP, or CSS transitions)
- High-quality AI-generated imagery (Louis has access to generators)
- Dark mode toggle
- RSS feed for blog
- Teaching section carousel/slider on landing page — replace static card grid with Bootstrap Carousel or Stimulus-driven Splide/Swiper; defer until Isara's content is in and layout reviewed

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
- [x] Hosting / deployment plan → **Heroku** (confirmed this session; `/deploy-heroku` skill available globally)
- Does Isara want an RSS feed for the blog?
- Teaching model: use `has_one_attached :image` (Active Storage → Cloudinary) or plain `image_url` string? — decide when implementing uploads
