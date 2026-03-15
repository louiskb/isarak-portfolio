class Teaching < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user

  has_one_attached :image

  validates :title, presence: true
end
