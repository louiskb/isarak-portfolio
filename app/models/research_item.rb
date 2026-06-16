class ResearchItem < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  CATEGORY_LABELS = {
    "journal_article" => "Journal Article",
    "edited_book" => "Edited Book",
    "book" => "Book",
    "book_chapter" => "Book Chapter",
    "thesis" => "Thesis",
    "conference_paper" => "Refereed Conference Paper",
    "white_paper" => "White Paper",
    "conference_presentation" => "Conference Presentation",
    "article" => "Article",
    "project" => "Project"
  }.freeze

  enum :category, CATEGORY_LABELS.keys.index_with { |k| k }
  enum :status, { draft: 0, scheduled: 1, published: 2 }

  belongs_to :user
  has_one_attached :image

  scope :published, -> { where(status: :published) }
  scope :visible_to_visitors, -> { published }

  validates :title, presence: true
  validates :category, presence: true

  # Default ordering for the index: newest publication first. Items without a
  # publication date sink to the bottom (Postgres puts NULLs first on DESC, so
  # NULLS LAST is explicit), tiebroken by most-recently-created.
  def self.by_recency
    order(Arel.sql("published_at DESC NULLS LAST, created_at DESC"))
  end

  # Re-stamp every item's position to match newest-first date order. Backs the
  # "Sort by most recent" reset button. update_columns skips validations and
  # callbacks — this only touches position.
  def self.sort_by_recency!
    transaction do
      by_recency.each_with_index do |item, index|
        item.update_columns(position: index)
      end
    end
  end
end
