class FixAlbumPositions < ActiveRecord::Migration[7.0]
  def up
    User.find_each do |user|
      albums = user.favorite_albums.order(:created_at)

      albums.each_with_index do |album, index|
        # 位置が設定されていない場合のみ設定
        if album.position_x.nil? || album.position_y.nil?
          grid_x = index % 5
          grid_y = index / 5
          album.update(
            position_x: grid_x * 140,
            position_y: grid_y * 140
          )
        end
      end
    end
  end

  def down
    # 必要に応じてロールバック処理
  end
end
