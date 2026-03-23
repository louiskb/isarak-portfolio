class AddExternalUrlToTeachings < ActiveRecord::Migration[8.1]
  def change
    add_column :teachings, :external_url, :string
  end
end
