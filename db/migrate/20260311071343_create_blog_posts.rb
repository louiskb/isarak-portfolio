class CreateBlogPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.string :author
      t.integer :status
      t.boolean :ai_generated
      t.datetime :scheduled_at
      t.string :slug

      t.timestamps
    end
  end
end
