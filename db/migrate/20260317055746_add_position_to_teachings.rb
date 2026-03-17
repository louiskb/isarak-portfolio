class AddPositionToTeachings < ActiveRecord::Migration[8.1]
  def change
    add_column :teachings, :position, :integer
  end
end
