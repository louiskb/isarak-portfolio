class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum :status, { draft: 0, scheduled: 1, published: 2 }

  belongs_to :user

  has_rich_text :body

  has_one_attached :featured_image
  has_many_attached :photos

  validates :title, presence: true
  validates :status, presence: true
  validate :one_content_field_only

  private

  def one_content_field_only
    if blog_post_erb_content.present? && body.present?
      errors.add(:base, "A post can only have rich text content or HTML content, not both.")
    end
  end
