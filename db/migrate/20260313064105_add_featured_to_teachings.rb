class AddFeaturedToTeachings < ActiveRecord::Migration[8.1]
  def change
    add_column :teachings, :featured, :boolean
  end
end
