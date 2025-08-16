class AddPositionToFavoriteAlbums < ActiveRecord::Migration[7.2]
  def change
    add_column :favorite_albums, :position_x, :integer
    add_column :favorite_albums, :position_y, :integer
  end
end
