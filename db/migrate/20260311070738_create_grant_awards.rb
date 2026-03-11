class CreateGrantAwards < ActiveRecord::Migration[8.1]
  def change
    create_table :grant_awards do |t|
      t.string :title
      t.text :description
      t.integer :year
      t.string :awarding_body
      t.integer :category
      t.string :slug

      t.timestamps
    end
  end
end
