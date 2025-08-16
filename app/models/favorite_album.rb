class FavoriteAlbum < ApplicationRecord
  belongs_to :user, optional: true # 一旦ユーザー機能がないので optional

  validates :spotify_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :artist, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
