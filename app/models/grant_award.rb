class GrantAward < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum :category, { grant: 0, award: 1 }

  belongs_to :user

  validates :title, presence: true
  validates :category, presence: true
end
