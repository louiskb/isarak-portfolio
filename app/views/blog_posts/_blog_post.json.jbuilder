json.extract! blog_post, :id, :title, :author, :status, :ai_generated, :scheduled_at, :slug, :created_at, :updated_at
json.url blog_post_url(blog_post, format: :json)
