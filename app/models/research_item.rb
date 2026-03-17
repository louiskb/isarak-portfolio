class ResearchItem < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  CATEGORY_LABELS = {
    "journal_article" => "Journal Article",
    "edited_book" => "Edited Book",
    "book" => "Book",
    "book_chapter" => "Book Chapter",
    "thesis" => "Thesis",
    "conference_paper" => "Conference Paper",
    "white_paper" => "White Paper",
    "conference_presentation" => "Conference Presentation",
    "article" => "Article",
    "project" => "Project"
  }.freeze

  enum :category, CATEGORY_LABELS.keys.index_with { |k| k }

  belongs_to :user
  has_one_attached :image

  validates :title, presence: true
  validates :category, presence: true
end
