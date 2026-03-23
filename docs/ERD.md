# isarak-portfolio — Entity Relationship Diagram

```mermaid
erDiagram
    USER {
        int id PK
        string email
        string encrypted_password
        string reset_password_token
        datetime reset_password_sent_at
        datetime remember_created_at
        string confirmation_token
        datetime confirmed_at
        datetime confirmation_sent_at
        string unconfirmed_email
        string name
        string slug
        datetime created_at
        datetime updated_at
    }

    RESEARCH_ITEM {
        int id PK
        int user_id FK
        string title
        string category
        text description
        string external_url
        string image_url
        boolean featured
        date published_at
        int status
        datetime scheduled_at
        string slug
        int position
        datetime created_at
        datetime updated_at
    }

    GRANT_AWARD {
        int id PK
        int user_id FK
        string title
        text description
        string year
        string awarding_body
        int category
        int status
        datetime scheduled_at
        string slug
        int position
        datetime created_at
        datetime updated_at
    }

    TEACHING {
        int id PK
        int user_id FK
        string title
        text description
        string institution
        string year
        string external_url
        string image_url
        boolean featured
        int status
        datetime scheduled_at
        string slug
        int position
        datetime created_at
        datetime updated_at
    }

    BLOG_POST {
        int id PK
        int user_id FK
        string title
        string author
        text blog_excerpt
        int status
        boolean featured
        boolean ai_generated
        boolean human_generated
        datetime scheduled_at
        string slug
        text blog_post_erb_content
        string image_url
        text featured_image_caption
        datetime created_at
        datetime updated_at
    }

    SERVICE {
        int id PK
        int user_id FK
        datetime created_at
        datetime updated_at
    }

    CONTACT {
        int id PK
        string first_name
        string last_name
        string email
        text message
        datetime created_at
        datetime updated_at
    }

    ACTION_TEXT_RICH_TEXT {
        int id PK
        string name
        text body
        string record_type
        int record_id FK
        datetime created_at
        datetime updated_at
    }

    ACTIVE_STORAGE_ATTACHMENT {
        int id PK
        string name
        string record_type
        int record_id FK
        int blob_id FK
        datetime created_at
    }

    ACTIVE_STORAGE_BLOB {
        int id PK
        string key
        string filename
        string content_type
        text metadata
        string service_name
        bigint byte_size
        string checksum
        datetime created_at
    }

    ACTIVE_STORAGE_VARIANT_RECORD {
        int id PK
        int blob_id FK
        string variation_digest
    }

    TAG {
        int id PK
        string name
        datetime created_at
        datetime updated_at
    }

    BLOG_POST_TAG {
        int id PK
        int blog_post_id FK
        int tag_id FK
        datetime created_at
        datetime updated_at
    }

    USER ||--o{ RESEARCH_ITEM : "has many"
    USER ||--o{ GRANT_AWARD : "has many"
    USER ||--o{ TEACHING : "has many"
    USER ||--o{ BLOG_POST : "has many"
    USER ||--o| SERVICE : "has one"
    USER ||--o| ACTIVE_STORAGE_ATTACHMENT : "has one (cv)"
    BLOG_POST ||--o| ACTION_TEXT_RICH_TEXT : "has rich text body"
    SERVICE ||--o| ACTION_TEXT_RICH_TEXT : "has rich text description"
    BLOG_POST ||--o| ACTIVE_STORAGE_ATTACHMENT : "has one (featured_image)"
    BLOG_POST ||--o{ ACTIVE_STORAGE_ATTACHMENT : "has many (photos)"
    ACTIVE_STORAGE_ATTACHMENT }o--|| ACTIVE_STORAGE_BLOB : "belongs to"
    ACTIVE_STORAGE_BLOB ||--o{ ACTIVE_STORAGE_VARIANT_RECORD : "has variants"
    BLOG_POST ||--o{ BLOG_POST_TAG : "has many"
    TAG ||--o{ BLOG_POST_TAG : "has many"
```

## Notes

- All owned resources (`ResearchItem`, `GrantAward`, `Teaching`, `BlogPost`, `Service`) have a `user_id` FK — each belongs to User (Isara)
- `category` is a Rails enum:
  - `ResearchItem`: string-backed — 10 categories: `journal_article / edited_book / book / book_chapter / thesis / conference_paper / white_paper / conference_presentation / article / project`
  - `GrantAward`: integer-backed — `grant (0) / award (1)`
- `BlogPost.status` enum: `draft / scheduled / published`
- `ResearchItem.status` enum: `draft (0) / scheduled (1) / published (2)` — same pattern as BlogPost; visitors only see published items; `scheduled_at` holds the auto-publish time
- `Teaching.status` enum: `draft (0) / scheduled (1) / published (2)` — same pattern; public show page exists; visitors only see published items
- `GrantAward.status` enum: `draft (0) / scheduled (1) / published (2)` — same pattern; no public show page (index is admin-only); status controls homepage visibility
- `BlogPost.body` — Action Text rich text (Trix editor). Stored in `action_text_rich_texts`, not in `blog_posts` table directly
- `BlogPost.blog_post_erb_content` — plain text column for AI-generated HTML/ERB content
- `BlogPost.blog_excerpt` — plain text short summary shown on index cards
- `BlogPost.featured` — flags posts for display on the homepage blog section
- `BlogPost.featured_image` — Active Storage `has_one_attached`; auto-set from Unsplash on AI posts
- `BlogPost.image_url` — plain string fallback; shown only when `featured_image` is not attached; passed through `ai_params` and saved by `BlogPostAiService`
- `BlogPost.featured_image_caption` — plain text column storing `<figcaption>` HTML for Unsplash photographer attribution; set by `BlogPostAiService` when an Unsplash URL is fetched; rendered with `raw` under the featured image on the show page; nil for uploaded images
- `BlogPost.photos` — Active Storage `has_many_attached`; available for manual uploads
- `BlogPost.human_generated` — boolean flag (default false); mirrors `ai_generated` for filtering
- `Service.description` — Action Text rich text stored in `action_text_rich_texts`; single record per user
- `GrantAward.featured` — REMOVED; all awards appear on homepage ordered by `position`; drag order on index = homepage order
- `Teaching.featured` — flags teachings for display on the homepage Teaching spotlight (max 3, ordered by `updated_at: :desc`)
- `ResearchItem.featured` — flags items for homepage Research section (max 4, ordered by `updated_at: :desc`)
- `position` (int) — on Teaching, ResearchItem, GrantAward; controls drag-and-drop display order on index pages only (does not affect homepage for Teaching/Research)
- `Teaching.external_url` — optional string; shown as a "More Information" link on the public show page; input in the edit form
- `ResearchItem.external_url` — optional string; shown as a "More Information" link on the public show page (was "View full paper" — renamed for consistency)
- `User.cv` — Active Storage `has_one_attached`; stored in Cloudinary via Active Storage
- `User.name` — display name (e.g. "Dr Isara Khanjanasthiti")
- `User.slug` — FriendlyId slug (based on email); used for readable URLs
- `Contact` — standalone model; no FK to User; stores contact form submissions only
- Active Storage uses Cloudinary as the backend in both development and production (`config.active_storage.service = :cloudinary`)
- `active_storage_variant_records` stores Cloudinary transformation references (not local files)
- `Tag.name` — unique case-insensitively; `before_save` normalises capitalisation using `\b[a-z]` regex (preserves hyphens, unlike `titleize`)
- `BlogPostTag` — join table; unique composite index on `[blog_post_id, tag_id]`; `has_many :through` from both sides
- Mermaid can't model polymorphic associations precisely — `ACTIVE_STORAGE_ATTACHMENT.record_type` holds the owner class name (`"User"`, `"BlogPost"`, `"Service"`, etc.) and `record_id` holds the owner's PK
