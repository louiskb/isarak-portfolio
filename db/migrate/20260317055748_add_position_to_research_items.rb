class AddPositionToResearchItems < ActiveRecord::Migration[8.1]
  def change
    add_column :research_items, :position, :integer
  end
end
