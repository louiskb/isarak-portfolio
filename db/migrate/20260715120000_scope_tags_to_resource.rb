class ScopeTagsToResource < ActiveRecord::Migration[8.1]
  # Previously every resource (blog, research, teaching, awards) shared one
  # global `tags` table. This isolates each resource's tag library by adding a
  # `resource_type` scope to tags.
  def up
    add_column :tags, :resource_type, :string

    # Existing tags were shared. The blog was the original owner, so keep them
    # as blog-only and give the other three resources a clean slate.
    execute "UPDATE tags SET resource_type = 'blog_post'"
    execute "DELETE FROM research_item_tags"
    execute "DELETE FROM teaching_tags"
    execute "DELETE FROM grant_award_tags"

    change_column_null :tags, :resource_type, false

    # Names are now unique per resource, not globally.
    remove_index :tags, name: "index_tags_on_name"
    add_index :tags, [ :resource_type, :name ], unique: true
    add_index :tags, :resource_type
  end

  def down
    remove_index :tags, column: [ :resource_type, :name ]
    remove_index :tags, column: :resource_type
    add_index :tags, :name, unique: true
    remove_column :tags, :resource_type
  end
end
