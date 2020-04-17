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

ActiveRecord::Schema.define(version: 2020_04_17_215318) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "all_events", force: :cascade do |t|
    t.string "event_type"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sum", default: 0
    t.bigint "employee_id", default: -1
    t.index ["event_type"], name: "index_all_events_on_event_type"
    t.index ["user_id"], name: "index_all_events_on_user_id"
  end

  create_table "employee_salary_events", force: :cascade do |t|
    t.bigint "all_event_id", null: false
    t.bigint "employee_id", null: false
    t.integer "sum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_employee_salary_events_on_all_event_id"
    t.index ["employee_id"], name: "index_employee_salary_events_on_employee_id"
  end

  create_table "employee_stocks", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "amount"
    t.bigint "employee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_employee_stocks_on_employee_id"
    t.index ["product_id"], name: "index_employee_stocks_on_product_id"
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

  create_table "end_work_session_events", force: :cascade do |t|
    t.bigint "all_event_id", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_end_work_session_events_on_all_event_id"
    t.index ["employee_id"], name: "index_end_work_session_events_on_employee_id"
  end

  create_table "equipment_events", force: :cascade do |t|
    t.bigint "all_event_id", null: false
    t.string "description", default: "Без описания"
    t.integer "sum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_equipment_events_on_all_event_id"
  end

  create_table "fare_events", force: :cascade do |t|
    t.bigint "all_event_id", null: false
    t.string "description", default: "Без описания"
    t.integer "sum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_fare_events_on_all_event_id"
  end

  create_table "giving_events", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "amount"
    t.bigint "employee_id", null: false
    t.bigint "all_event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_giving_events_on_all_event_id"
    t.index ["employee_id"], name: "index_giving_events_on_employee_id"
    t.index ["product_id"], name: "index_giving_events_on_product_id"
  end

  create_table "other_expense_events", force: :cascade do |t|
    t.bigint "all_event_id", null: false
    t.string "description", default: "Без описания"
    t.integer "sum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_other_expense_events_on_all_event_id"
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

  create_table "selling_events", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "amount"
    t.bigint "all_event_id", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_selling_events_on_all_event_id"
    t.index ["employee_id"], name: "index_selling_events_on_employee_id"
    t.index ["product_id"], name: "index_selling_events_on_product_id"
  end

  create_table "shopping_events", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "amount"
    t.bigint "all_event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_shopping_events_on_all_event_id"
    t.index ["product_id"], name: "index_shopping_events_on_product_id"
  end

  create_table "start_work_session_events", force: :cascade do |t|
    t.bigint "all_event_id", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_start_work_session_events_on_all_event_id"
    t.index ["employee_id"], name: "index_start_work_session_events_on_employee_id"
  end

  create_table "taking_events", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "amount"
    t.bigint "employee_id", null: false
    t.bigint "all_event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_taking_events_on_all_event_id"
    t.index ["employee_id"], name: "index_taking_events_on_employee_id"
    t.index ["product_id"], name: "index_taking_events_on_product_id"
  end

  create_table "tax_events", force: :cascade do |t|
    t.bigint "all_event_id", null: false
    t.string "description", default: "Без описания"
    t.integer "sum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_tax_events_on_all_event_id"
  end

  create_table "throwing_events", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "amount"
    t.bigint "all_event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["all_event_id"], name: "index_throwing_events_on_all_event_id"
    t.index ["product_id"], name: "index_throwing_events_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false
    t.bigint "earned", default: 0
    t.bigint "throwed", default: 0
    t.integer "in_stock", default: 0
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
  add_foreign_key "employee_salary_events", "all_events"
  add_foreign_key "employee_salary_events", "employees"
  add_foreign_key "employee_stocks", "employees"
  add_foreign_key "employee_stocks", "products"
  add_foreign_key "employees", "users"
  add_foreign_key "end_work_session_events", "all_events"
  add_foreign_key "end_work_session_events", "employees"
  add_foreign_key "equipment_events", "all_events"
  add_foreign_key "fare_events", "all_events"
  add_foreign_key "giving_events", "all_events"
  add_foreign_key "giving_events", "employees"
  add_foreign_key "giving_events", "products"
  add_foreign_key "other_expense_events", "all_events"
  add_foreign_key "products", "users"
  add_foreign_key "selling_events", "all_events"
  add_foreign_key "selling_events", "employees"
  add_foreign_key "selling_events", "products"
  add_foreign_key "shopping_events", "all_events"
  add_foreign_key "shopping_events", "products"
  add_foreign_key "start_work_session_events", "all_events"
  add_foreign_key "start_work_session_events", "employees"
  add_foreign_key "taking_events", "all_events"
  add_foreign_key "taking_events", "employees"
  add_foreign_key "taking_events", "products"
  add_foreign_key "tax_events", "all_events"
  add_foreign_key "throwing_events", "all_events"
  add_foreign_key "throwing_events", "products"
  add_foreign_key "warehouses", "products"
  add_foreign_key "warehouses", "users"
end
