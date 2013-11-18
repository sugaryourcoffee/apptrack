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

ActiveRecord::Schema.define(version: 20131118185645) do

  create_table "comments", force: true do |t|
    t.string   "title"
    t.text     "comment"
    t.integer  "track_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "comments", ["track_id"], name: "index_comments_on_track_id"

  create_table "projects", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "url_home"
    t.string   "url_repository"
    t.string   "url_docs"
    t.string   "url_test"
    t.string   "url_staging"
    t.string   "url_production"
  end

  create_table "tracks", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "category"
    t.integer  "sequence"
    t.string   "status"
  end

  add_index "tracks", ["project_id"], name: "index_tracks_on_project_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
