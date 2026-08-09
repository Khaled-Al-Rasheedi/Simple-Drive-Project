
ActiveRecord::Schema[8.1].define(version: 2026_08_08_230901) do
  create_table "api_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_api_tokens_on_token", unique: true
  end

  create_table "blobs", id: false, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "id", null: false
    t.integer "size", null: false
    t.string "storage_backend", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_blobs_on_id", unique: true
  end
end
