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

ActiveRecord::Schema[8.1].define(version: 2026_08_09_170116) do
  create_table "api_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_tokens_on_token", unique: true
  end

  create_table "blob_storages", force: :cascade do |t|
    t.string "blob_id", null: false
    t.datetime "created_at", null: false
    t.binary "data", null: false
    t.datetime "updated_at", null: false
    t.index ["blob_id"], name: "index_blob_storages_on_blob_id", unique: true
  end

  create_table "blobs", id: false, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "id", null: false
    t.integer "size", null: false
    t.string "storage_backend", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_blobs_on_id", unique: true
  end

  add_foreign_key "blob_storages", "blobs"
end
