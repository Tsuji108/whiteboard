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

ActiveRecord::Schema.define(version: 20170606150339) do

  create_table "accept_passes", force: :cascade do |t|
    t.string   "accept_pass"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  create_table "mailing_lists", force: :cascade do |t|
    t.string   "from_name"
    t.string   "title"
    t.boolean  "to_enrolled",  default: true
    t.boolean  "to_graduated", default: false
    t.text     "content"
    t.boolean  "saved",        default: false
    t.boolean  "sent",         default: false
    t.datetime "sent_at"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["user_id"], name: "index_mailing_lists_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "timetable_id"
    t.string   "band_name"
    t.integer  "resavation_date"
    t.string   "resavation_koma"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["resavation_date"], name: "index_reservations_on_resavation_date"
    t.index ["resavation_koma"], name: "index_reservations_on_resavation_koma"
    t.index ["timetable_id"], name: "index_reservations_on_timetable_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "timetables", force: :cascade do |t|
    t.date     "from_date"
    t.date     "to_date"
    t.text     "times"
    t.boolean  "saved",        default: false
    t.boolean  "published",    default: false
    t.datetime "published_at"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["user_id"], name: "index_timetables_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "birth_place"
    t.string   "address"
    t.string   "sex",                  default: "男"
    t.date     "birth_day"
    t.date     "enroll_year"
    t.string   "department"
    t.string   "part"
    t.text     "genre"
    t.text     "profile"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                default: false
    t.string   "activation_digest"
    t.boolean  "activated",            default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "graduated",            default: false
    t.boolean  "mail_receive",         default: true
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "checked_notification", default: false, null: false
    t.string   "prof_img"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
