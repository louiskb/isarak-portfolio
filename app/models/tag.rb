class Tag < ApplicationRecord
  has_many :blog_post_tags, dependent: :destroy
  has_many :blog_posts, through: :blog_post_tags

  has_many :research_item_tags, dependent: :destroy
  has_many :research_items, through: :research_item_tags

  has_many :teaching_tags, dependent: :destroy
  has_many :teachings, through: :teaching_tags

  has_many :grant_award_tags, dependent: :destroy
  has_many :grant_awards, through: :grant_award_tags

  # Each resource owns an isolated tag library — a tag belongs to exactly one.
  RESOURCE_TYPES = %w[blog_post research_item teaching grant_award].freeze

  validates :resource_type, presence: true, inclusion: { in: RESOURCE_TYPES }
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false, scope: :resource_type }

  scope :for_resource, ->(type) { where(resource_type: type) }

  # Capitalise the first letter of each word, preserving hyphens.
  # titleize strips hyphens ("Transit-Oriented" → "Transit Oriented"), so use \b instead.
  before_save { self.name = name.strip.gsub(/\b[a-z]/) { |m| m.upcase } }
end
