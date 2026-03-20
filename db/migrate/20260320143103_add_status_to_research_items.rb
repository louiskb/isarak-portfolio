class AddStatusToResearchItems < ActiveRecord::Migration[8.1]
  def change
    add_column :research_items, :status, :integer, default: 0, null: false
    add_column :research_items, :scheduled_at, :datetime
  end
end
