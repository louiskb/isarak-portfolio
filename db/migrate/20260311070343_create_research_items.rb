class CreateResearchItems < ActiveRecord::Migration[8.1]
  def change
    create_table :research_items do |t|
      t.string :title
      t.integer :category
      t.text :description
      t.string :external_url
      t.boolean :featured
      t.date :published_at
      t.string :slug

      t.timestamps
    end
  end
end
