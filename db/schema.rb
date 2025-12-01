# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_12_01_072737) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "enemies", force: :cascade do |t|
    t.integer "hitpoints"
    t.string "name"
    t.string "sprite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "strength"
    t.string "weakness"
  end

  create_table "fight_questions", force: :cascade do |t|
    t.bigint "fight_id", null: false
    t.bigint "question_id", null: false
    t.integer "selected_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fight_id"], name: "index_fight_questions_on_fight_id"
    t.index ["question_id"], name: "index_fight_questions_on_question_id"
  end

  create_table "fights", force: :cascade do |t|
    t.string "status"
    t.integer "enemy_hitpoints"
    t.integer "player_hitpoints"
    t.bigint "user_id", null: false
    t.bigint "enemy_id", null: false
    t.bigint "story_level_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enemy_id"], name: "index_fights_on_enemy_id"
    t.index ["story_level_id"], name: "index_fights_on_story_level_id"
    t.index ["user_id"], name: "index_fights_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "question_type"
    t.string "question"
    t.jsonb "answers"
    t.integer "correct_index"
    t.string "difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "story_levels", force: :cascade do |t|
    t.text "story_content"
    t.string "map_image"
    t.integer "map_node"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "character_name"
    t.integer "hitpoints", default: 100
    t.integer "experience_points", default: 0
    t.integer "level", default: 0
    t.integer "japanese_difficulty"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "fight_questions", "fights"
  add_foreign_key "fight_questions", "questions"
  add_foreign_key "fights", "enemies"
  add_foreign_key "fights", "story_levels"
  add_foreign_key "fights", "users"
end
