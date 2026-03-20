class AddFeaturedImageCaptionToBlogPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :blog_posts, :featured_image_caption, :text
  end
end
