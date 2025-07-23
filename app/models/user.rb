class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  # ユーザーがお気に入りに追加したライブイベント
  has_many :favorites, dependent: :destroy
  has_many :favorite_live_events, through: :favorites, source: :live_event
end
