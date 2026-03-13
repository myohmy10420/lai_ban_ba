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

ActiveRecord::Schema[8.0].define(version: 2026_03_13_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "location_id", null: false
    t.bigint "user_id"
    t.string "name", null: false
    t.string "phone"
    t.date "start_on"
    t.date "end_on"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_employees_on_account_id"
    t.index ["location_id"], name: "index_employees_on_location_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_locations_on_account_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["user_id", "account_id"], name: "index_memberships_on_user_id_and_account_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "shift_assignments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "shift_id", null: false
    t.bigint "employee_id", null: false
    t.string "status"
    t.bigint "assigned_by_user_id"
    t.datetime "assigned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_shift_assignments_on_account_id"
    t.index ["employee_id"], name: "index_shift_assignments_on_employee_id"
    t.index ["shift_id"], name: "index_shift_assignments_on_shift_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "location_id", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "required_headcount"
    t.string "role_tag"
    t.string "source"
    t.integer "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "starts_at"], name: "index_shifts_on_account_id_and_starts_at"
    t.index ["account_id"], name: "index_shifts_on_account_id"
    t.index ["location_id"], name: "index_shifts_on_location_id"
    t.index ["starts_at"], name: "index_shifts_on_starts_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "phone"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "employees", "accounts"
  add_foreign_key "employees", "locations"
  add_foreign_key "employees", "users"
  add_foreign_key "locations", "accounts"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "users"
  add_foreign_key "shift_assignments", "accounts"
  add_foreign_key "shift_assignments", "employees"
  add_foreign_key "shift_assignments", "shifts"
  add_foreign_key "shifts", "accounts"
  add_foreign_key "shifts", "locations"
end
