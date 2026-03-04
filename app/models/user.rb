class User < ApplicationRecord
extend FriendlyId
friendly_id :email, use: :slugged # Use email as slug (unique)
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
