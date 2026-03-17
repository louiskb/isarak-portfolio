class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum :status, { draft: 0, scheduled: 1, published: 2 }

  belongs_to :user

  has_many :blog_post_tags, dependent: :destroy
  has_many :tags, through: :blog_post_tags

  has_rich_text :body

  has_one_attached :featured_image
  has_many_attached :photos

  attr_accessor :keep_featured_image

  before_validation :set_author

  validates :title, presence: true
  validates :status, presence: true
  validate :one_content_field_only

  # Returns a display label for AI involvement, shown to Isara only.
  # nil when no AI was involved (pure manual, or manual with no AI revision).
  # human_generated alone (!ai_generated) → nil (nothing shown)
  def ai_label
    return "Revised with AI" if ai_generated? && human_generated?
    return "Created with AI" if ai_generated?
    nil
  end

  private

  def set_author
    self.author = "Isara Khanjanasthiti"
  end

  def one_content_field_only
    if blog_post_erb_content.present? && body.present?
      errors.add(:base, "A post can only have rich text content or HTML content, not both.")
    end
  end
end
