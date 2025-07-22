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

ActiveRecord::Schema[8.0].define(version: 2025_07_22_105020) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.json "selections", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["created_at"], name: "index_cart_items_on_created_at"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_carts_on_created_at"
    t.index ["session_id"], name: "index_carts_on_session_id", unique: true
    t.index ["user_id"], name: "index_carts_on_user_id"
    t.check_constraint "user_id IS NOT NULL OR session_id IS NOT NULL", name: "user_or_session_required"
  end

  create_table "compatibility_rules", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "condition_part_id", null: false
    t.bigint "condition_choice_id", null: false
    t.bigint "target_part_id"
    t.bigint "target_choice_id"
    t.string "action", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_choice_id"], name: "index_compatibility_rules_on_condition_choice_id"
    t.index ["condition_part_id"], name: "index_compatibility_rules_on_condition_part_id"
    t.index ["product_id", "action"], name: "index_compatibility_rules_on_product_id_and_action"
    t.index ["product_id", "condition_part_id", "condition_choice_id"], name: "index_compatibility_rules_on_condition"
    t.index ["product_id"], name: "index_compatibility_rules_on_product_id"
    t.index ["target_choice_id"], name: "index_compatibility_rules_on_target_choice_id"
    t.index ["target_part_id"], name: "index_compatibility_rules_on_target_part_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.json "selections", null: false
    t.string "product_name", null: false
    t.text "product_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "product_id"], name: "index_order_items_on_order_id_and_product_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "status", default: "pending", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.text "shipping_address"
    t.text "billing_address"
    t.text "notes"
    t.string "customer_email"
    t.string "customer_name"
    t.string "customer_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_orders_on_created_at"
    t.index ["customer_email"], name: "index_orders_on_customer_email"
    t.index ["status", "created_at"], name: "index_orders_on_status_and_created_at"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id", "created_at"], name: "index_orders_on_user_id_and_created_at"
    t.index ["user_id", "status"], name: "index_orders_on_user_id_and_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "part_choices", force: :cascade do |t|
    t.bigint "part_id", null: false
    t.string "name", null: false
    t.decimal "base_price", precision: 10, scale: 2, default: "0.0", null: false
    t.boolean "in_stock", default: true
    t.text "description"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["in_stock"], name: "index_part_choices_on_in_stock"
    t.index ["part_id", "in_stock"], name: "index_part_choices_on_part_id_and_in_stock"
    t.index ["part_id", "name"], name: "index_part_choices_on_part_id_and_name"
    t.index ["part_id"], name: "index_part_choices_on_part_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string "name", null: false
    t.string "part_type", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_type", "name"], name: "index_parts_on_part_type_and_name"
    t.index ["part_type"], name: "index_parts_on_part_type"
  end

  create_table "pricing_rules", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "part_choice_id"
    t.json "conditions", null: false
    t.decimal "price_adjustment", precision: 10, scale: 2, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_choice_id"], name: "index_pricing_rules_on_part_choice_id"
    t.index ["product_id", "price_adjustment"], name: "index_pricing_rules_on_product_id_and_price_adjustment"
    t.index ["product_id"], name: "index_pricing_rules_on_product_id"
  end

  create_table "product_parts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "part_id", null: false
    t.boolean "required", default: true
    t.integer "display_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["part_id"], name: "index_product_parts_on_part_id"
    t.index ["product_id", "display_order"], name: "index_product_parts_on_product_id_and_display_order"
    t.index ["product_id", "part_id"], name: "index_product_parts_on_product_id_and_part_id", unique: true
    t.index ["product_id"], name: "index_product_parts_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.decimal "base_price", precision: 10, scale: 2, null: false
    t.string "category", default: "bicycle", null: false
    t.boolean "active", default: true
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_products_on_active"
    t.index ["category", "active"], name: "index_products_on_category_and_active"
    t.index ["category"], name: "index_products_on_category"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.string "role", default: "customer", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role", "active"], name: "index_users_on_role_and_active"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "compatibility_rules", "part_choices", column: "condition_choice_id"
  add_foreign_key "compatibility_rules", "part_choices", column: "target_choice_id"
  add_foreign_key "compatibility_rules", "parts", column: "condition_part_id"
  add_foreign_key "compatibility_rules", "parts", column: "target_part_id"
  add_foreign_key "compatibility_rules", "products"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "part_choices", "parts"
  add_foreign_key "pricing_rules", "part_choices"
  add_foreign_key "pricing_rules", "products"
  add_foreign_key "product_parts", "parts"
  add_foreign_key "product_parts", "products"
end
