class CreateTeachings < ActiveRecord::Migration[8.1]
  def change
    create_table :teachings do |t|
      t.string :title
      t.text :description
      t.string :institution
      t.integer :year
      t.string :image_url
      t.string :slug

      t.timestamps
    end
  end
end
