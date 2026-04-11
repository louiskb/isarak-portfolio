class AddCardSummaryToResources < ActiveRecord::Migration[8.1]
  def change
    add_column :research_items, :card_summary, :text
    add_column :teachings, :card_summary, :text
    add_column :grant_awards, :card_summary, :text
  end
end
