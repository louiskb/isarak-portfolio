class AddHumanGeneratedToBlogPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :blog_posts, :human_generated, :boolean, default: false, null: false
  end
end
