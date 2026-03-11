# isarak-portfolio — Entity Relationship Diagram

```mermaid
erDiagram
    USER {
        int id PK
        string email
        string encrypted_password
        string name
        text bio
        datetime created_at
        datetime updated_at
    }

    RESEARCH_ITEM {
        int id PK
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
        string title
        int status
        boolean ai_generated
        datetime scheduled_at
        string slug
        datetime created_at
        datetime updated_at
    }

    ACTIVE_STORAGE_ATTACHMENT {
        int id PK
        string name
        string record_type
        int record_id FK
        int blob_id FK
    }

    USER ||--o{ ACTIVE_STORAGE_ATTACHMENT : "has CV"
    BLOG_POST ||--o{ ACTIVE_STORAGE_ATTACHMENT : "has rich text attachments"
```

## Notes

- No `user_id` FK on resources — Isara is the only user, resources are managed content not owned records
- `category` is a Rails enum (stored as `int`, mapped to labels)
  - `ResearchItem`: `project / paper / publication`
  - `GrantAward`: `grant / award`
- `BlogPost.status` enum: `draft / scheduled / published`
- `ActionText` rich text body (blog posts) lives in `action_text_rich_texts` — managed by Rails automatically
- CV attachment on `User` handled by Active Storage
