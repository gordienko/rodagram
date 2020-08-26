class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :user_addresses, dependent: :destroy
  validates :login, presence: true, uniqueness: true
end