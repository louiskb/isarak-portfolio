require "test_helper"

class ResearchItemTest < ActiveSupport::TestCase
  test "sort_by_recency! stamps positions newest publication first" do
    isara = users(:isara)
    ResearchItem.delete_all

    older  = ResearchItem.create!(title: "Older", category: "journal_article", user: isara, published_at: Date.new(2020, 1, 1))
    newer  = ResearchItem.create!(title: "Newer", category: "journal_article", user: isara, published_at: Date.new(2024, 1, 1))
    undated = ResearchItem.create!(title: "Undated", category: "journal_article", user: isara, published_at: nil)

    ResearchItem.sort_by_recency!

    # Newest date first, oldest date next, no-date last.
    assert_equal [ newer.id, older.id, undated.id ],
                 ResearchItem.order(:position).pluck(:id)
  end
end
