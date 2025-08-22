# db/migrate/20250820172308_add_position_column_to_favorite_albums.rb
class AddPositionColumnToFavoriteAlbums < ActiveRecord::Migration[7.2]
  def change
    # positionカラムが既に存在する場合はスキップ
    unless column_exists?(:favorite_albums, :position)
      add_column :favorite_albums, :position, :integer, default: 1
    end

    # インデックスが存在しない場合のみ追加
    unless index_exists?(:favorite_albums, :position)
      add_index :favorite_albums, :position
    end
  end
end
