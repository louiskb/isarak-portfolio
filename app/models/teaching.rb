class Teaching < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user

  has_one_attached :image

  enum :status, { draft: 0, scheduled: 1, published: 2 }

  scope :published, -> { where(status: :published) }
  scope :visible_to_visitors, -> { published }

  validates :title, presence: true
end
