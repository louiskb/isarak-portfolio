class RemoveAboutFromUsersRemoveDescriptionFromServices < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :about, :text
    remove_column :services, :description, :text
  end
end
