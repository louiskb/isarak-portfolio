class AddImageUrlToResearchItems < ActiveRecord::Migration[8.1]
  def change
    add_column :research_items, :image_url, :string
  end
end
