class RemoveFeaturedFromGrantAwards < ActiveRecord::Migration[8.1]
  def change
    remove_column :grant_awards, :featured, :boolean
  end
end
