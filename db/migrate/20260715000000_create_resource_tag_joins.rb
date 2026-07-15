class CreateResourceTagJoins < ActiveRecord::Migration[8.1]
  def change
    create_table :research_item_tags do |t|
      t.references :research_item, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :research_item_tags, [ :research_item_id, :tag_id ], unique: true

    create_table :teaching_tags do |t|
      t.references :teaching, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :teaching_tags, [ :teaching_id, :tag_id ], unique: true

    create_table :grant_award_tags do |t|
      t.references :grant_award, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :grant_award_tags, [ :grant_award_id, :tag_id ], unique: true
  end
end
