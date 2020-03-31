# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_31_163557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "all_events", force: :cascade do |t|
    t.string "event_type"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_all_events_on_user_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.integer "fixed_rate", default: 0
    t.integer "interest_rate", default: 0
    t.boolean "working", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true
    t.index ["name"], name: "index_employees_on_name", unique: true
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "price_in"
    t.integer "price_out"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "amount"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_warehouses_on_product_id"
    t.index ["user_id"], name: "index_warehouses_on_user_id"
  end

  add_foreign_key "all_events", "users"
  add_foreign_key "employees", "users"
  add_foreign_key "products", "users"
  add_foreign_key "warehouses", "products"
  add_foreign_key "warehouses", "users"
end
