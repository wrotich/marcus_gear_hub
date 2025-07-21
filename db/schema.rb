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

ActiveRecord::Schema[8.0].define(version: 2025_07_14_145049) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "part_option_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["part_option_id"], name: "index_cart_items_on_part_option_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incompatibilities", force: :cascade do |t|
    t.bigint "part_option_id", null: false
    t.bigint "incompatible_with_id", null: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["incompatible_with_id"], name: "index_incompatibilities_on_incompatible_with_id"
    t.index ["part_option_id"], name: "index_incompatibilities_on_part_option_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id"
    t.decimal "total"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "part_options", force: :cascade do |t|
    t.bigint "part_id", null: false
    t.string "name"
    t.decimal "additional_price"
    t.boolean "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_part_options_on_part_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "price_modifiers", force: :cascade do |t|
    t.bigint "part_option_id", null: false
    t.bigint "depends_on_id", null: false
    t.decimal "adjusted_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["depends_on_id"], name: "index_price_modifiers_on_depends_on_id"
    t.index ["part_option_id"], name: "index_price_modifiers_on_part_option_id"
  end

  create_table "product_parts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "part_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_product_parts_on_part_id"
    t.index ["product_id"], name: "index_product_parts_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id", null: false
    t.decimal "base_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "part_options"
  add_foreign_key "cart_items", "products"
  add_foreign_key "incompatibilities", "part_options"
  add_foreign_key "incompatibilities", "part_options", column: "incompatible_with_id"
  add_foreign_key "part_options", "parts"
  add_foreign_key "price_modifiers", "part_options"
  add_foreign_key "price_modifiers", "part_options", column: "depends_on_id"
  add_foreign_key "product_parts", "parts"
  add_foreign_key "product_parts", "products"
end
