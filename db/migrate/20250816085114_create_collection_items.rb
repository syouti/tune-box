class CreateCollectionItems < ActiveRecord::Migration[7.2]
  def change
    create_table :collection_items do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :album, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
