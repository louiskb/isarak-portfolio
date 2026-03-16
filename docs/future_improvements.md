# Future Improvements — isarak-portfolio

> Maintained by Louis + Claude. Add ideas here as they come up during development.
> Last updated: 2026-03-17 (session 11)

---

## High Priority (do soon)

### Real Content from Isara
- [ ] Replace all seed/placeholder content with Isara's real bio, avatar, CV, and featured items
- [ ] Mark featured items (research, teaching, grants/awards) to show on landing page
- [ ] Set `APP_HOST` and `SMTP_PASSWORD` in `.env` for production mailer

### SEO & Social Sharing
- [ ] **Open Graph meta tags** — add `og:title`, `og:description`, `og:image`, `og:url` to blog show pages; required for proper link previews when sharing on LinkedIn, X, iMessage etc. (the copy link button is only as good as the preview it generates)
- [ ] **Sitemap.xml** — auto-generated from published blog posts + research items; helps Google index the site; use `sitemap_generator` gem or a custom rake task

### CV Page-1 Preview
- [ ] Use Cloudinary's PDF-to-image transformation (`/pg_1/`) to show a thumbnail of Isara's CV on the landing page About section; "Download CV" link below it

---

## Medium Priority

### Blog UX
- [ ] **Reading time estimate** — calculate words ÷ 200 wpm on BlogPost; display "5 min read" on show page and index cards
- [ ] **Related posts** — show 2–3 posts at the bottom of each blog show page (same category or recent); keeps visitors on site longer
- [ ] **Table of contents** — auto-generate from `<h2>` / `<h3>` tags in AI-generated posts; show as sticky sidebar or collapsible block at the top of long posts
- [ ] **Blog post tags** — many-to-many tags on BlogPost (e.g. "Urban Planning", "Aviation", "Teaching"); filter by tag on the blog index
- [ ] **Reading progress bar** — thin teal bar at top of viewport that fills as user scrolls through a blog post; elegant signal for long-form content

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
- [ ] **Pin Ruby version in Gemfile** — add `ruby "3.3.9"` (or latest) to suppress the Heroku warning on every deploy
- [ ] **Pin Node.js buildpack** — add `heroku/nodejs` buildpack before `heroku/ruby` to pin the Node version and suppress the Node.js warning
- [ ] **Plausible or Fathom analytics** — privacy-first, cookie-free analytics (consistent with the Privacy Policy's "no tracking cookies" claim); embed via a single `<script>` tag

---

## Decisions to Revisit Later

- Will Isara need the Teaching and Grants "View all →" pages public (currently auth-gated)?
- Should the Service page be more detailed (committee roles, peer review, etc.) or stay as a single rich-text block?
- RSS feed format preference — Atom vs RSS 2.0?
- Analytics: does Isara want any traffic data, or is the Privacy Policy "no analytics" stance a deliberate choice?
