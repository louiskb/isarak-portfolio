# Isarak Portfolio

A professional portfolio and blog platform for **Dr Isara Khanjanasthiti**, an urban planning academic at the University of New England (UNE), Sydney campus.

Built with Ruby on Rails 8 as client work by [Louis Bourne](https://github.com/louiskb).

## What It Does

**For visitors:**
- Browse Isara's academic profile, research areas, teaching highlights, and career history
- Read Isara's blog (written manually or AI-generated with Unsplash imagery)
- Download documents — CV, research papers, publications
- Get in touch via a contact form (spam-protected, email confirmation sent to sender)

**For Isara (authenticated):**
- Log in and manage all portfolio content via a simple admin interface
- Create and publish blog posts with a rich text editor and image uploads
- Schedule blog posts for future publication (including AI-generated posts)
- Generate blog post drafts using AI (powered by `ruby_llm` + OpenAI)
- Revise AI-generated posts with follow-up prompts
- Add, edit, and remove portfolio resources (research papers, publications, talks, grants, awards) that appear on the public landing page
- Upload and manage a downloadable CV

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Ruby on Rails 8.1 |
| Database | PostgreSQL |
| Styling | Bootstrap 5.3 + SCSS |
| Authentication | Devise |
| Rich Text | Action Text (Trix) |
| File Uploads | Cloudinary + Active Storage |
| Friendly URLs | FriendlyId |
| Pagination | Pagy |
| AI Generation | RubyLLM (OpenAI) |
| Background Jobs | Solid Queue |
| Frontend | Hotwire (Turbo + Stimulus) |
| Spam Protection | invisible_captcha |
| Images | Unsplash API (AI-generated posts) |

## Local Setup

### Prerequisites

- Ruby 3.2+
- PostgreSQL
- A Cloudinary account
- An OpenAI API key (for AI blog generation)
- An Unsplash API access key (for blog post images)
- An iCloud (or other SMTP) account for email

### Steps

```bash
git clone <repo>
cd isarak-portfolio
bundle install

# Create your .env file and fill in credentials (see Environment Variables below)
cp .env.example .env   # or create .env manually

# Set up databases (app DB + Solid Queue secondary DB)
bin/rails db:create
bin/rails db:schema:load
bin/rails db:migrate

# Start the server + background worker together
bin/dev
```

### Environment Variables

Create a `.env` file at the project root with the following:

```bash
# Cloudinary
CLOUDINARY_URL=cloudinary://<api_key>:<api_secret>@<cloud_name>

# AI (OpenAI via RubyLLM)
OPENAI_API_KEY=sk-...

# Unsplash (for blog post images)
UNSPLASH_ACCESS_KEY=...

# Email (SMTP — iCloud or other provider)
MAILER_SENDER=noreply@yourdomain.com
SMTP_ADDRESS=smtp.mail.me.com
SMTP_PORT=587
SMTP_DOMAIN=icloud.com
SMTP_USERNAME=your@icloud.com
SMTP_PASSWORD=your-app-specific-password

# App host (used in email links)
APP_HOST=localhost:3000
```

> **Note:** `CLOUDINARY_URL` must not have an inline comment on the same line — dotenv will include it in the value and break the URI parser.

### Creating the admin user

There is no sign-up flow. Create Isara's account directly in the Rails console:

```ruby
bin/rails console
User.create!(email: "isara@example.com", password: "...", password_confirmation: "...")
```

## Key Commands

```bash
bin/dev                       # Start server + Solid Queue worker (recommended)
bin/rails server              # Server only
bin/rails console             # Rails console
bin/rails db:migrate          # Run migrations
bundle exec rubocop -a        # Auto-fix linting
```

## Notes

- Isara is the **only authenticated user** — there is no public sign-up
- Scheduled posts are published by `PublishScheduledPostsJob`, which runs every minute via Solid Queue
- `bin/dev` uses `Procfile.dev` to run both the Rails server and the Solid Queue worker — both are needed for scheduling to work
- AI blog generation uses `ruby_llm` with structured output; inline images use Unsplash placeholders injected at generation time
- The contact form sends an admin notification to Isara and a confirmation email to the sender

---

Rails app generated with [louiskb/rails-startup-templates](https://github.com/louiskb/rails-startup-templates).
