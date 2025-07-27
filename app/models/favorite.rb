class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :live_event

  # 同じユーザーが同じライブを複数回お気に入りできないようにする
  validates :user_id, uniqueness: { scope: :live_event_id }
end
