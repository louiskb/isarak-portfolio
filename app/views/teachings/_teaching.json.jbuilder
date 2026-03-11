json.extract! teaching, :id, :title, :description, :institution, :year, :image_url, :slug, :created_at, :updated_at
json.url teaching_url(teaching, format: :json)
