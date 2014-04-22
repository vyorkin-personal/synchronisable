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

ActiveRecord::Schema.define(version: 20140422140817) do

  create_table "imports", force: true do |t|
    t.string   "synchronizable_type", null: false
    t.integer  "synchronizable_id",   null: false
    t.text     "attrs"
    t.string   "remote_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "imports", ["remote_id"], name: "index_imports_on_remote_id"
  add_index "imports", ["synchronizable_type", "synchronizable_id"], name: "index_imports_on_synchronizable_type_and_synchronizable_id"

  create_table "match_players", force: true do |t|
    t.integer  "match_id"
    t.integer  "player_id"
    t.string   "ref_type"
    t.integer  "formation_index"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "match_players", ["match_id"], name: "index_match_players_on_match_id"
  add_index "match_players", ["player_id"], name: "index_match_players_on_player_id"

  create_table "matches", force: true do |t|
    t.integer  "beginning"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.string   "weather"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.string   "citizenship"
    t.float    "height"
    t.float    "weight"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id"

  create_table "stadiums", force: true do |t|
    t.string   "name"
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "country"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
