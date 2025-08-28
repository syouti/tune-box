class AddIndexesForPerformance < ActiveRecord::Migration[7.2]
  def change
    # ユーザーテーブルのインデックス（既存のインデックスはスキップ）
    add_index :users, :created_at unless index_exists?(:users, :created_at)

    # お気に入りアルバムテーブルのインデックス
    add_index :favorite_albums, :user_id unless index_exists?(:favorite_albums, :user_id)
    add_index :favorite_albums, :spotify_id unless index_exists?(:favorite_albums, :spotify_id)
    add_index :favorite_albums, [:user_id, :spotify_id], unique: true unless index_exists?(:favorite_albums, [:user_id, :spotify_id])
    add_index :favorite_albums, :created_at unless index_exists?(:favorite_albums, :created_at)

    # ライブイベントテーブルのインデックス
    add_index :live_events, :date unless index_exists?(:live_events, :date)
    add_index :live_events, :artist unless index_exists?(:live_events, :artist)
    add_index :live_events, :venue unless index_exists?(:live_events, :venue)
    add_index :live_events, :created_at unless index_exists?(:live_events, :created_at)
  end
end
