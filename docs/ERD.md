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
        string slug
        datetime created_at
        datetime updated_at
    }

    RESEARCH_ITEM {
        int id PK
        int user_id FK
        string title
        int category
        text description
        string external_url
        boolean featured
        date published_at
        string slug
        datetime created_at
        datetime updated_at
    }

    GRANT_AWARD {
        int id PK
        int user_id FK
        string title
        text description
        int year
        string awarding_body
        int category
        string slug
        datetime created_at
        datetime updated_at
    }

    TEACHING {
        int id PK
        int user_id FK
        string title
        text description
        string institution
        int year
        string image_url
        string slug
        datetime created_at
        datetime updated_at
    }

    BLOG_POST {
        int id PK
        int user_id FK
        string title
        string author
        int status
        boolean ai_generated
        datetime scheduled_at
        string slug
        text blog_post_erb_content
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

    USER ||--o{ RESEARCH_ITEM : "has many"
    USER ||--o{ GRANT_AWARD : "has many"
    USER ||--o{ TEACHING : "has many"
    USER ||--o{ BLOG_POST : "has many"
    USER ||--o| ACTIVE_STORAGE_ATTACHMENT : "has one (cv)"
    BLOG_POST ||--o| ACTION_TEXT_RICH_TEXT : "has rich text body"
    BLOG_POST ||--o| ACTIVE_STORAGE_ATTACHMENT : "has one (featured_image)"
    BLOG_POST ||--o{ ACTIVE_STORAGE_ATTACHMENT : "has many (photos)"
    ACTIVE_STORAGE_ATTACHMENT }o--|| ACTIVE_STORAGE_BLOB : "belongs to"
    ACTIVE_STORAGE_BLOB ||--o{ ACTIVE_STORAGE_VARIANT_RECORD : "has variants"
```

## Notes

- All owned resources (`ResearchItem`, `GrantAward`, `Teaching`, `BlogPost`) have a `user_id` FK — each belongs to User (Isara)
- `category` is a Rails enum (stored as `int`, mapped to labels):
  - `ResearchItem`: `project / paper / publication`
  - `GrantAward`: `grant / award`
- `BlogPost.status` enum: `draft / scheduled / published`
- `BlogPost.body` — Action Text rich text (Trix editor). Stored in `action_text_rich_texts`, not in `blog_posts` table directly
- `BlogPost.blog_post_erb_content` — plain text column for AI-generated HTML/ERB content
- `BlogPost.featured_image` — Active Storage `has_one_attached`; auto-set from Unsplash on AI posts
- `BlogPost.photos` — Active Storage `has_many_attached`; available for manual uploads
- `User.cv` — Active Storage `has_one_attached`; stored in Cloudinary via Active Storage
- `User.slug` — FriendlyId slug (based on email); used for readable URLs
- `Contact` — standalone model; no FK to User; stores contact form submissions only
- Active Storage uses Cloudinary as the backend in both development and production (`config.active_storage.service = :cloudinary`)
- `active_storage_variant_records` stores Cloudinary transformation references (not local files)
- Mermaid can't model polymorphic associations precisely — `ACTIVE_STORAGE_ATTACHMENT.record_type` holds the owner class name (`"User"`, `"BlogPost"`, etc.) and `record_id` holds the owner's PK
