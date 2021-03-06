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

ActiveRecord::Schema.define(version: 20150402232325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "codes", force: :cascade do |t|
    t.integer "code",     null: false
    t.integer "time",     null: false
    t.integer "track_id", null: false
  end

  add_index "codes", ["code", "time", "track_id"], name: "index_codes_on_code_and_time_and_track_id", unique: true, using: :btree

  create_table "tracks", force: :cascade do |t|
    t.string   "external_id"
    t.string   "version"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "duration",    null: false
  end

  add_index "tracks", ["id"], name: "index_tracks_on_id", unique: true, using: :btree
  add_index "tracks", ["version"], name: "index_tracks_on_version", using: :btree

end
