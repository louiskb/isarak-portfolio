# Isarak Portfolio

A professional portfolio and blog platform for **Isara**, a professor and academic lecturer at the University of New South Wales (UNSW), Australia.

Built with Ruby on Rails 8.

## What It Does

**For visitors:**
- Browse Isara's academic profile, research areas, and career highlights
- Read Isara's blog (written manually or AI-generated)
- Download documents — CV, research papers, publications
- Get in touch via a contact form

**For Isara (authenticated):**
- Log in and manage all portfolio content via a simple admin interface
- Create and publish blog posts with a rich text editor and image uploads
- Schedule blog posts for future publication (including AI-generated posts)
- Generate blog post drafts using AI (powered by `ruby_llm`)
- Add, edit, and remove portfolio resources (research papers, publications, talks, etc.) that appear on the public landing page

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Ruby on Rails 8.1 |
| Database | PostgreSQL |
| Styling | Bootstrap 5.3 + SCSS |
| Authentication | Devise |
| Rich Text | Action Text |
| File Uploads | Cloudinary |
| Friendly URLs | FriendlyId |
| Pagination | Pagy |
| AI Generation | RubyLLM |
| Background Jobs | Solid Queue |
| Frontend | Hotwire (Turbo + Stimulus) |

## Local Setup

```bash
git clone <repo>
cd isarak-portfolio
bundle install
bin/rails db:setup
bin/rails server
```

Copy `.env.example` to `.env` and fill in your credentials (Cloudinary, AI API key, etc.).

---

Rails app generated with [louiskb/rails-startup-templates](https://github.com/louiskb/rails-startup-templates).
