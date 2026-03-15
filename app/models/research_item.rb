class ResearchItem < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum :category, { project: 0, paper: 1, publication: 2 }

  belongs_to :user
  has_one_attached :image

  validates :title, presence: true
  validates :category, presence: true
end
