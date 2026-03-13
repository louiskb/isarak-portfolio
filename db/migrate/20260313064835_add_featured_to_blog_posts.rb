class AddFeaturedToBlogPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :blog_posts, :featured, :boolean
  end
end
