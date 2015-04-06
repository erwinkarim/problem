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

ActiveRecord::Schema.define(version: 20150403083146) do

  create_table "admins", force: :cascade do |t|
    t.string   "samaccountname"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "issue_extra_info_details", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "use_field"
  end

  create_table "issue_extra_infos", force: :cascade do |t|
    t.integer  "extra_info_detail_id"
    t.integer  "issue_id"
    t.string   "string_val"
    t.integer  "int_val"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "issue_extra_infos", ["extra_info_detail_id"], name: "index_issue_extra_infos_on_extra_info_detail_id"
  add_index "issue_extra_infos", ["issue_id"], name: "index_issue_extra_infos_on_issue_id"

  create_table "issue_statuses", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "issue_trackers", force: :cascade do |t|
    t.integer  "issue_id"
    t.integer  "old_status_id"
    t.integer  "new_status_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "comment"
  end

  add_index "issue_trackers", ["issue_id"], name: "index_issue_trackers_on_issue_id"
  add_index "issue_trackers", ["new_status_id"], name: "index_issue_trackers_on_new_status_id"
  add_index "issue_trackers", ["old_status_id"], name: "index_issue_trackers_on_old_status_id"
  add_index "issue_trackers", ["user_id"], name: "index_issue_trackers_on_user_id"

  create_table "issues", force: :cascade do |t|
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "assignee_id"
  end

  add_index "issues", ["assignee_id"], name: "index_issues_on_assignee_id"
  add_index "issues", ["user_id"], name: "index_issues_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.string   "domain"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
