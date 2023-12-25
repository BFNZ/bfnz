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

ActiveRecord::Schema[7.0].define(version: 2023_11_21_192632) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.string "ISBN"
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cancelled_order_events", id: :serial, force: :cascade do |t|
    t.integer "cancelled_by_id"
    t.integer "customer_id"
    t.text "order_details"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["cancelled_by_id"], name: "index_cancelled_order_events_on_cancelled_by_id"
    t.index ["customer_id"], name: "index_cancelled_order_events_on_customer_id"
  end

  create_table "contact_lists", id: :serial, force: :cascade do |t|
    t.integer "territorial_authority_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["territorial_authority_id"], name: "index_contact_lists_on_territorial_authority_id"
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.integer "territorial_authority_id"
    t.integer "contact_list_id"
    t.integer "created_by_id"
    t.integer "updated_by_id"
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "address", limit: 255
    t.string "suburb", limit: 255
    t.string "city_town", limit: 255
    t.string "post_code", limit: 255
    t.string "ta", limit: 255
    t.string "pxid", limit: 255
    t.string "phone", limit: 255
    t.string "email", limit: 255
    t.string "title", limit: 255
    t.boolean "tertiary_student"
    t.string "tertiary_institution", limit: 255
    t.text "admin_notes"
    t.text "coordinator_notes"
    t.integer "old_subscriber_id"
    t.string "old_system_address", limit: 255
    t.string "old_system_suburb", limit: 255
    t.string "old_system_city_town", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "parent_id"
    t.integer "further_contact_requested", default: 0
    t.boolean "bad_address", default: false
    t.string "dpid", limit: 255
    t.decimal "x", precision: 10, scale: 6
    t.decimal "y", precision: 10, scale: 6
    t.index ["address"], name: "index_customers_on_address"
    t.index ["city_town"], name: "index_customers_on_city_town"
    t.index ["contact_list_id"], name: "index_customers_on_contact_list_id"
    t.index ["created_by_id"], name: "index_customers_on_created_by_id"
    t.index ["email"], name: "index_customers_on_email"
    t.index ["first_name"], name: "index_customers_on_first_name"
    t.index ["further_contact_requested"], name: "index_customers_on_further_contact_requested"
    t.index ["last_name"], name: "index_customers_on_last_name"
    t.index ["parent_id"], name: "index_customers_on_parent_id"
    t.index ["phone"], name: "index_customers_on_phone"
    t.index ["suburb"], name: "index_customers_on_suburb"
    t.index ["territorial_authority_id"], name: "index_customers_on_territorial_authority_id"
    t.index ["updated_by_id"], name: "index_customers_on_updated_by_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.string "entry_type"
    t.date "date"
    t.integer "book_id"
    t.integer "quantity"
    t.decimal "unit_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.string "author", limit: 255
    t.string "code", limit: 255, null: false
    t.string "image_path", limit: 255
    t.string "description", limit: 1000
    t.datetime "deactivated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "items_orders", id: false, force: :cascade do |t|
    t.integer "item_id"
    t.integer "order_id"
    t.index ["item_id"], name: "index_items_orders_on_item_id"
    t.index ["order_id"], name: "index_items_orders_on_order_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.integer "shipment_id"
    t.text "admin_notes"
    t.text "coordinator_notes"
    t.integer "method_of_discovery"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "ip_address", limit: 40
    t.string "session_identifier", limit: 100
    t.integer "method_received"
    t.boolean "duplicate", default: false
    t.integer "created_by_id"
    t.integer "updated_by_id"
    t.integer "customer_id"
    t.integer "table_id"
    t.index ["created_by_id"], name: "index_orders_on_created_by_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["duplicate"], name: "index_orders_on_duplicate"
    t.index ["shipment_id"], name: "index_orders_on_shipment_id"
    t.index ["updated_by_id"], name: "index_orders_on_updated_by_id"
  end

  create_table "shipments", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["created_at"], name: "index_shipments_on_created_at"
  end

  create_table "tables", id: :serial, force: :cascade do |t|
    t.string "coordinator_phone"
    t.string "coordinator_email"
    t.text "location"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "coordinator_first_name"
    t.string "coordinator_last_name"
    t.string "city"
  end

  create_table "territorial_authorities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "code", null: false
    t.string "addressfinder_name", limit: 255, null: false
    t.integer "coordinator_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["addressfinder_name"], name: "index_territorial_authorities_on_addressfinder_name"
    t.index ["coordinator_id"], name: "index_territorial_authorities_on_coordinator_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.string "crypted_password", limit: 255, null: false
    t.string "password_salt", limit: 255, null: false
    t.string "persistence_token", limit: 255, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "admin", default: false
    t.string "name", limit: 255
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "orders", "tables"
end
