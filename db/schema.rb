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

ActiveRecord::Schema.define(version: 2017_03_13_000042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "actions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "causes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkins", id: :serial, force: :cascade do |t|
    t.string "phone_number"
    t.integer "hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_question"
    t.index ["phone_number"], name: "index_checkins_on_phone_number"
  end

  create_table "follows", id: :serial, force: :cascade do |t|
    t.integer "from_user_id"
    t.string "to"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "peers", id: :serial, force: :cascade do |t|
    t.integer "from_user_id"
    t.string "to"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_actions", id: :serial, force: :cascade do |t|
    t.integer "action_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_causes", id: :serial, force: :cascade do |t|
    t.integer "cause_id"
    t.integer "user_id"
    t.boolean "primary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_skills", id: :serial, force: :cascade do |t|
    t.integer "skill_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.float "hours_pledged"
    t.string "phone_number"
    t.string "zipcode"
    t.string "twitter_handle"
    t.boolean "enable_text_checkins"
    t.boolean "enable_start_conversations"
    t.string "resume_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "signup_blob"
    t.integer "hours_spent_last_week"
    t.integer "referring_user_id"
    t.string "url"
    t.string "company"
    t.string "party_identification"
    t.boolean "has_working_group"
    t.boolean "has_organization"
  end

end
