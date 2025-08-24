class AddPositionColumnsToFavoriteAlbums < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:favorite_albums, :position_x)
      add_column :favorite_albums, :position_x, :integer
    end

    unless column_exists?(:favorite_albums, :position_y)
      add_column :favorite_albums, :position_y, :integer
    end
  end
end
