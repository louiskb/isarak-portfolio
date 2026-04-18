class AddAuthorsToResearchItems < ActiveRecord::Migration[8.1]
  def change
    add_column :research_items, :authors, :string
  end
end
