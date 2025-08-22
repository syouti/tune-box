class AddPositionToFavoriteAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :favorite_albums, :position, :integer, default: 1
    add_index :favorite_albums, :position
  end
end
