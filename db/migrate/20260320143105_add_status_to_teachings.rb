class AddStatusToTeachings < ActiveRecord::Migration[8.1]
  def change
    add_column :teachings, :status, :integer, default: 0, null: false
    add_column :teachings, :scheduled_at, :datetime
  end
end
