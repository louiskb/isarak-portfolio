class AddFeaturedToGrantAwards < ActiveRecord::Migration[8.1]
  def change
    add_column :grant_awards, :featured, :boolean
  end
end
