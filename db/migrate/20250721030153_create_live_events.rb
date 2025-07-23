class CreateLiveEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :live_events do |t|
      t.string :title
      t.string :artist
      t.string :venue
      t.datetime :date
      t.text :description
      t.string :ticket_url
      t.integer :price
      t.string :prefecture

      t.timestamps
    end
  end
end
