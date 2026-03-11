json.extract! research_item, :id, :title, :category, :description, :external_url, :featured, :published_at, :slug, :created_at, :updated_at
json.url research_item_url(research_item, format: :json)
