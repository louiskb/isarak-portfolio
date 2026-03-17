class AddPositionToGrantAwards < ActiveRecord::Migration[8.1]
  def change
    add_column :grant_awards, :position, :integer
  end
end
