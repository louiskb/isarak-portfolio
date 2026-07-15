class GrantAward < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum :category, { grant: 0, award: 1 }
  enum :status, { draft: 0, scheduled: 1, published: 2 }

  belongs_to :user

  has_many :grant_award_tags, dependent: :destroy
  has_many :tags, through: :grant_award_tags

  scope :published, -> { where(status: :published) }

  validates :title, presence: true
  validates :category, presence: true
end
