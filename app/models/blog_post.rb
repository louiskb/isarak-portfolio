class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum :status, { draft: 0, scheduled: 1, published: 2 }

  belongs_to :user

  has_rich_text :body

  has_many_attached :photos

  validates :title, presence: true
  validates :status, presence: true
end
