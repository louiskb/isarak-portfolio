class UpdateResearchItemCategoriesToStrings < ActiveRecord::Migration[8.1]
  # Old integer enum: { project: 0, paper: 1, publication: 2 }
  # Migrated to closest new string category (Isara should review after):
  #   project     → "project"
  #   paper       → "article"
  #   publication → "journal_article"
  OLD_MAP = { 0 => "project", 1 => "article", 2 => "journal_article" }.freeze

  def up
    add_column :research_items, :category_str, :string

    execute("SELECT id, category FROM research_items").each do |row|
      new_val = OLD_MAP[row["category"].to_i]
      execute("UPDATE research_items SET category_str = '#{new_val}' WHERE id = #{row['id']}")
    end

    remove_column :research_items, :category
    rename_column :research_items, :category_str, :category
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
