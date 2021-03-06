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

ActiveRecord::Schema.define(version: 20170110043230) do

  create_table "activities", force: :cascade do |t|
    t.datetime "start_date"
    t.float    "distance"
    t.float    "elevation_gain"
    t.integer  "moving_time"
    t.string   "title"
    t.text     "comments"
    t.integer  "strava_activity_id"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.text     "summary_polyline"
    t.integer  "sport"
    t.string   "small_map_file_name"
    t.string   "small_map_content_type"
    t.integer  "small_map_file_size"
    t.datetime "small_map_updated_at"
    t.string   "large_map_file_name"
    t.string   "large_map_content_type"
    t.integer  "large_map_file_size"
    t.datetime "large_map_updated_at"
    t.index ["strava_activity_id"], name: "index_activities_on_strava_activity_id", unique: true
    t.index ["user_id", "start_date"], name: "index_activities_on_user_id_and_start_date"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.integer  "strava_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "remember_digest"
    t.boolean  "admin",            default: false
    t.integer  "unit_preference",  default: 0
    t.string   "strava_token"
    t.float    "fundraising_goal", default: 100.0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["strava_id"], name: "index_users_on_strava_id", unique: true
  end

end
