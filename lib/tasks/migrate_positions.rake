namespace :favorite_albums do
  desc "Migrate existing position data from 140px to 148px grid system"
  task migrate_positions: :environment do
    puts "🔄 Starting position migration..."

    favorite_albums = FavoriteAlbum.all
    migrated_count = 0

    favorite_albums.each do |album|
      if album.position_x.present? && album.position_y.present?
        # 古い140px計算で保存された位置を検出
        if album.position_y % 140 == 0 && album.position_y < 700
          old_grid_y = album.position_y / 140
          new_position_y = old_grid_y * 148

          # 位置を更新
          album.update!(
            position_x: album.position_x,
            position_y: new_position_y
          )

          puts "🔄 Migrated album '#{album.name}': #{album.position_y_was}px → #{new_position_y}px"
          migrated_count += 1
        end
      end
    end

    puts "✅ Position migration completed: #{migrated_count} albums migrated"
  end
end
