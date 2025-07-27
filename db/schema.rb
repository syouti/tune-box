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

ActiveRecord::Schema[7.2].define(version: 2025_07_27_201318) do
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
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "favorites", "live_events"
  add_foreign_key "favorites", "users"
end
