class AddBlogExcerptToBlogPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :blog_posts, :blog_excerpt, :text
  end
end
