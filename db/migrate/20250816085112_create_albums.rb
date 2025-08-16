class CreateAlbums < ActiveRecord::Migration[7.2]
  def change
    create_table :albums do |t|
      t.string :spotify_id
      t.string :name
      t.string :artist
      t.text :image_url

      t.timestamps
    end
  end
end
