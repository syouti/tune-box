class User < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :favorited_live_events, through: :favorites, source: :live_event

  def favorited?(live_event)
    favorites.exists?(live_event: live_event)
  end
end
