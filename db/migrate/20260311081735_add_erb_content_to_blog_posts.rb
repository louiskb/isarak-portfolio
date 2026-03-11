class AddErbContentToBlogPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :blog_posts, :blog_post_erb_content, :text
  end
end
