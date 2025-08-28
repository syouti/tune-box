# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_08_28_000002) do
  create_table "albums", force: :cascade do |t|
    t.string "spotify_id"
    t.string "name"
    t.string "artist"
    t.text "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collection_items", force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "album_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_collection_items_on_album_id"
    t.index ["collection_id"], name: "index_collection_items_on_collection_id"
  end

  create_table "collections", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "favorite_albums", force: :cascade do |t|
    t.integer "user_id"
    t.string "spotify_id"
    t.string "name"
    t.string "artist"
    t.string "image_url"
    t.string "external_url"
    t.string "release_date"
    t.integer "total_tracks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position_x"
    t.integer "position_y"
    t.integer "position", default: 1
    t.boolean "created_by_premium_user", default: false
    t.integer "share_count", default: 0
    t.datetime "last_shared_at"
    t.index ["created_at"], name: "index_favorite_albums_on_created_at"
    t.index ["created_by_premium_user"], name: "index_favorite_albums_on_created_by_premium_user"
    t.index ["position"], name: "index_favorite_albums_on_position"
    t.index ["spotify_id"], name: "index_favorite_albums_on_spotify_id"
    t.index ["user_id", "spotify_id"], name: "index_favorite_albums_on_user_id_and_spotify_id", unique: true
    t.index ["user_id"], name: "index_favorite_albums_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "live_event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["live_event_id"], name: "index_favorites_on_live_event_id"
    t.index ["user_id", "live_event_id"], name: "index_favorites_on_user_id_and_live_event_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "live_events", force: :cascade do |t|
    t.string "title"
    t.string "artist"
    t.string "venue"
    t.datetime "date"
    t.text "description"
    t.string "ticket_url"
    t.integer "price"
    t.string "prefecture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist"], name: "index_live_events_on_artist"
    t.index ["created_at"], name: "index_live_events_on_created_at"
    t.index ["date"], name: "index_live_events_on_date"
    t.index ["venue"], name: "index_live_events_on_venue"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "premium", default: false
    t.string "subscription_status", default: "free"
    t.string "stripe_customer_id"
    t.string "subscription_id"
    t.datetime "trial_ends_at"
    t.datetime "last_login_at"
    t.integer "login_count", default: 0
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["premium"], name: "index_users_on_premium"
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id"
  end

  add_foreign_key "collection_items", "albums"
  add_foreign_key "collection_items", "collections"
  add_foreign_key "collections", "users"
  add_foreign_key "favorites", "live_events"
  add_foreign_key "favorites", "users"
end
