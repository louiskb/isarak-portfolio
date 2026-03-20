class AddStatusToGrantAwards < ActiveRecord::Migration[8.1]
  def change
    add_column :grant_awards, :status, :integer, default: 0, null: false
    add_column :grant_awards, :scheduled_at, :datetime
  end
end
