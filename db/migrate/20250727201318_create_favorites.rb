class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :live_event, null: false, foreign_key: true

      t.timestamps
    end

    # 同じユーザーが同じイベントを重複してお気に入りできないようにする
    add_index :favorites, [:user_id, :live_event_id], unique: true
  end
end
