# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_24_195525) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "body", null: false
    t.bigint "user_id", null: false
    t.inet "creator_ip", null: false
    t.decimal "average_rating", precision: 25, scale: 16, default: "0.0"
    t.integer "sum_rating", default: 0
    t.integer "rates_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["average_rating", "rates_count"], name: "index_posts_on_average_rating_and_rates_count"
    t.index ["average_rating"], name: "index_posts_on_average_rating"
    t.index ["creator_ip"], name: "index_posts_on_creator_ip"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "rates", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.integer "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_rates_on_post_id"
  end

  create_table "user_addresses", force: :cascade do |t|
    t.inet "ip", null: false
    t.bigint "user_id", null: false
    t.index ["ip", "user_id"], name: "index_user_addresses_on_ip_and_user_id", unique: true
    t.index ["ip"], name: "index_user_addresses_on_ip"
    t.index ["user_id"], name: "index_user_addresses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "login", null: false
    t.integer "posts_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "posts", "users", on_delete: :cascade
  add_foreign_key "rates", "posts", on_delete: :cascade
  add_foreign_key "user_addresses", "users", on_delete: :cascade
end
