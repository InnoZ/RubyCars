# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160210124824) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "admin_areas", force: :cascade do |t|
    t.geometry "geom",   limit: {:srid=>4326, :type=>"geometry"}
    t.string   "name"
    t.string   "region"
    t.string   "admin"
  end

  create_table "companies", id: false, force: :cascade do |t|
    t.string   "id",         null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "companies", ["id"], name: "index_companies_on_id", unique: true, using: :btree

  create_table "providers", id: false, force: :cascade do |t|
    t.string   "id",                 null: false
    t.string   "company_id",         null: false
    t.string   "name",               null: false
    t.float    "centroid_latitude"
    t.float    "centroid_longitude"
    t.string   "extra"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "providers", ["id"], name: "index_providers_on_id", unique: true, using: :btree

  create_table "regions", id: false, force: :cascade do |t|
    t.string   "id",         null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "regions", ["id"], name: "index_regions_on_id", unique: true, using: :btree

  create_table "stations", id: false, force: :cascade do |t|
    t.string   "id",          null: false
    t.string   "provider_id", null: false
    t.string   "region_id",   null: false
    t.float    "latitude",    null: false
    t.float    "longitude",   null: false
    t.integer  "cars",        null: false
    t.string   "extra"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "stations", ["id"], name: "index_stations_on_id", unique: true, using: :btree

  add_foreign_key "providers", "companies"
  add_foreign_key "stations", "providers"
  add_foreign_key "stations", "regions"
end
