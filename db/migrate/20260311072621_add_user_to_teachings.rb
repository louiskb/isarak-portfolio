class AddUserToTeachings < ActiveRecord::Migration[8.1]
  def change
    add_reference :teachings, :user, null: false, foreign_key: true
  end
end
