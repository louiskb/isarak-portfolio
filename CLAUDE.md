# CLAUDE.md — isarak-portfolio

## What This App Is
A professional portfolio and blog platform for **Isara**, a professor/academic lecturer at NSW University, Australia. Built by Louis Bourne as client work (free, for a friend).

Visitors can browse Isara's research, publications, and blog. Isara logs in to manage all content.

## Reference Repo
Louis's own portfolio (same structure, use as reference):
- **Repo**: https://github.com/louiskb/louis-porfolio
- This app mirrors the structure — check it when uncertain about layout or conventions.

## Figma (Landing Page)
- https://www.figma.com/design/urlKYDQaoyIghxaQg69bYC/isarak-portfolio
- Landing page only — build this **last**, after all backend is in place.

## Tech Stack
- **Rails 8.1** with PostgreSQL
- **Bootstrap 5.3** + SCSS for styling
- **Devise** for authentication (Isara is the only user)
- **FriendlyId** for readable URLs on all public-facing resources
- **Cloudinary** for image uploads
- **Pagy** for pagination
- **RubyLLM** for AI blog post generation
- **Solid Queue** for background jobs (scheduled posts)
- **Action Text** (rich text editor for blog posts)
- **Hotwire** (Turbo + Stimulus) for SPA-like interactions

## Color Scheme
- **Primary**: Teal `#0D9488`
- **Text**: Dark gray `#1F2937`
- **Background**: White `#FFFFFF`
- **Section bg**: Light gray `#F3F4F6`

## Typography (Google Fonts)
- **Headings**: Playfair Display (serif — academic, authoritative)
- **Body**: Inter (sans-serif — clean, modern)

## Build Order
1. Navbar + footer
2. Backend (models, controllers, admin management for all resource types)
3. Blog + AI blog builder
4. Landing page (reference Figma + animations)

## Key Commands
```bash
rails server              # Start dev server
rails console             # Rails console
rails db:migrate          # Run migrations
bundle exec rubocop -a    # Auto-fix linting
```

## Conventions
- Double quotes throughout (Ruby, ERB, JS, HTML attributes)
- 2-space indentation
- Conventional commits (`feat:`, `fix:`, `chore:`, etc.)
- RuboCop enforced via `.rubocop.yml` (check for one at root)
- All public-facing resources use FriendlyId slugs

## Important Notes
- Isara is the **only authenticated user** — no public sign-up
- Scheduled blog posts work for both manual and AI-generated posts
- AI blog generation uses the `ruby_llm` gem
- Document downloads (CV, research papers) served via Active Storage or Cloudinary
- Contact form on landing page uses Action Mailer
