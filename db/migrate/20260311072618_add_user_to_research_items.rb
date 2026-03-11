class AddUserToResearchItems < ActiveRecord::Migration[8.1]
  def change
    add_reference :research_items, :user, null: false, foreign_key: true
  end
end
