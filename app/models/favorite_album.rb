class FavoriteAlbum < ApplicationRecord
  belongs_to :user, optional: true # 一旦ユーザー機能がないので optional

  # 基本的なバリデーション
  validates :spotify_id, presence: true, uniqueness: { scope: :user_id }, spotify_id: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :artist, presence: true, length: { maximum: 255 }
  validates :image_url, url: true, allow_blank: true
  validates :external_url, url: true, allow_blank: true
  validates :release_date, presence: true
  validates :total_tracks, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  # 位置情報のバリデーション
  validates :position_x, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 560 }
  validates :position_y, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 592 }

  scope :recent, -> { order(created_at: :desc) }

  # セキュリティ: データのサニタイズ
  before_save :sanitize_data

  private

  def sanitize_data
    self.name = sanitize_string(name) if name.present?
    self.artist = sanitize_string(artist) if artist.present?
  end

  def sanitize_string(str)
    # HTMLタグとスクリプトを除去
    ActionController::Base.helpers.sanitize(str, tags: [])
  end
end
