# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_03_195015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "car_features", force: :cascade do |t|
    t.bigint "feature_id"
    t.bigint "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_car_features_on_car_id"
    t.index ["feature_id"], name: "index_car_features_on_feature_id"
  end

  create_table "cars", force: :cascade do |t|
    t.datetime "last_seen"
    t.string "title"
    t.string "vin"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transmission"
    t.integer "power_kw"
    t.datetime "manufactured"
    t.integer "odometer"
    t.integer "fuel"
  end

  create_table "crawls", force: :cascade do |t|
    t.bigint "car_id"
    t.text "body"
    t.datetime "parsed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_crawls_on_car_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "car_features", "cars"
  add_foreign_key "car_features", "features"
  add_foreign_key "crawls", "cars"
end
