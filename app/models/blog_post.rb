class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum :status, { draft: 0, scheduled: 1, published: 2 }

  belongs_to :user

  validates :title, presence: true
  validates :status, presence: true
end
