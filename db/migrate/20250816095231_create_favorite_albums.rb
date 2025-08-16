class CreateFavoriteAlbums < ActiveRecord::Migration[7.2]
  def change
    create_table :favorite_albums do |t|
      t.integer :user_id
      t.string :spotify_id
      t.string :name
      t.string :artist
      t.string :image_url
      t.string :external_url
      t.string :release_date
      t.integer :total_tracks

      t.timestamps
    end
  end
end
