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

ActiveRecord::Schema.define(version: 20161230234622) do

  create_table "activities", force: :cascade do |t|
    t.datetime "start_date"
    t.float    "distance"
    t.float    "elevation_gain"
    t.integer  "moving_time"
    t.string   "title"
    t.text     "comments"
    t.integer  "strava_activity_id"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "summary_polyline"
    t.index ["user_id", "start_date"], name: "index_activities_on_user_id_and_start_date"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.integer  "strava_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "password_digest"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "preferred_units",   default: "feet"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
