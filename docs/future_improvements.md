# Future Improvements — isarak-portfolio

> Maintained by Louis + Claude. Add ideas here as they come up during development.
> Last updated: 2026-03-20 (session 19)

---

## High Priority (do soon)

### Real Content from Isara
- [x] Replace all seed/placeholder content with Isara's real bio, avatar, CV, and featured items
- [x] Mark featured items (research, teaching, grants/awards) to show on landing page
- [x] Set `APP_HOST` and `SMTP_PASSWORD` in `.env` for production mailer

### SEO & Social Sharing
- [ ] **Open Graph meta tags** — add `og:title`, `og:description`, `og:image`, `og:url` to blog show pages; required for proper link previews when sharing on LinkedIn, X, iMessage etc. (the copy link button is only as good as the preview it generates)
- [ ] **Sitemap.xml** — auto-generated from published blog posts + research items; helps Google index the site; use `sitemap_generator` gem or a custom rake task

### CV Page-1 Preview
- [ ] Use Cloudinary's PDF-to-image transformation (`/pg_1/`) to show a thumbnail of Isara's CV on the landing page About section; "Download CV" link below it

---

## Medium Priority

### Blog UX
- [x] **Reading time estimate** — `BlogPost#reading_time` method; strips HTML/plain text, divides word count by 200 wpm; shows on show page meta row + index card meta row ✅ (2026-03-20)
- [x] **Related posts** — show 2–3 posts at bottom of show page (same tags → recent fallback); `@related_posts` in controller, card grid in view ✅ (2026-03-20)
- [x] **Table of contents** — `toc_controller.js` scans `h2`/`h3` in content, injects nav above post; hidden if fewer than 2 headings ✅ (2026-03-20)
- [x] **Blog post tags / category filtering** — `Tag` model + `BlogPostTag` join table; filter pills on blog index with Stimulus + GET params + Turbo Drive replace; search bar with 400ms debounce; clear-all × button ✅ (2026-03-18/20)
- [x] **Reading progress bar** — `reading_progress_controller.js`; fixed 3px teal bar at top of viewport, fills on scroll ✅ (2026-03-20)

### Animations & Polish
- [ ] **Scroll-triggered animations** — AOS (Animate On Scroll) or CSS `@keyframes` with `IntersectionObserver`; trigger fade-up on below-fold sections (About, Research, Teaching, Awards, Blog, Contact)
- [ ] **Micro-interactions** — hover lift on research/blog cards, subtle scale on social icons

### Research & Downloads
- [ ] **Research PDF downloads** — allow Isara to attach a PDF to each ResearchItem (the paper itself); show a "Download PDF" button on research cards for open-access papers
- [ ] **Teaching image uploads** — `has_one_attached :image` on Teaching model (currently uses `image_url` string only); consistent with how other models handle images

---

## Lower Priority / Nice to Have

### Content Discovery
- [ ] **Blog search** — full-text search on blog title + excerpt + content; use PostgreSQL `pg_search` or a simple `ILIKE` query; add a search input to the blog index page
- [ ] **RSS feed** — `rss` gem or custom controller action rendering XML; lets people subscribe in feed readers; link in `<head>` so browsers discover it automatically
- [ ] **Email newsletter** — opt-in form on blog index; notify subscribers when a new post is published; use `Mailchimp` API or a simple custom mailer with unsubscribe token

### Admin / Isara UX
- [ ] **Bulk status actions** — select multiple draft posts and publish/schedule in one go; helpful once the blog has more content
- [ ] **Post analytics** — track view counts on blog posts; store as an integer column incremented on each `show` visit (no third-party JS needed); display to Isara only
- [ ] **Draft autosave** — periodically POST the blog form fields to a `/autosave` endpoint via Stimulus + fetch; never lose a long draft

### Internationalisation
- [ ] **Thai language support** — Isara is Thai-Australian; consider `i18n` with EN/TH locale toggle; low priority unless Isara has a Thai-speaking audience to target

### Infrastructure
- [x] **Pin Ruby version in Gemfile** — `ruby "3.3.10"` in Gemfile + `.ruby-version` ✅ (2026-03-18)
- [x] **Pin Node.js buildpack** — `engines.node: "22.x"` in `package.json` ✅ (2026-03-18)
- [ ] **Plausible or Fathom analytics** — privacy-first, cookie-free analytics (consistent with the Privacy Policy's "no tracking cookies" claim); embed via a single `<script>` tag

---

## Decisions to Revisit Later

- Will Isara need the Teaching and Grants "View all →" pages public (currently auth-gated)?
- Should the Service page be more detailed (committee roles, peer review, etc.) or stay as a single rich-text block?
- RSS feed format preference — Atom vs RSS 2.0?
- Analytics: does Isara want any traffic data, or is the Privacy Policy "no analytics" stance a deliberate choice?
