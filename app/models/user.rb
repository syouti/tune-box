class User < ApplicationRecord
  has_secure_password

  # アソシエーションを追加
  has_many :favorite_albums, dependent: :destroy
  has_many :albums, through: :favorite_albums

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
