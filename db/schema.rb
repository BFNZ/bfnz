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

ActiveRecord::Schema[7.0].define(version: 2017_05_10_022444) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cancelled_order_events", force: :cascade do |t|
    t.integer "cancelled_by_id"
    t.integer "customer_id"
    t.text "order_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cancelled_by_id"], name: "index_cancelled_order_events_on_cancelled_by_id"
    t.index ["customer_id"], name: "index_cancelled_order_events_on_customer_id"
  end

  create_table "contact_lists", force: :cascade do |t|
    t.integer "territorial_authority_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["territorial_authority_id"], name: "index_contact_lists_on_territorial_authority_id"
  end

  create_table "customers", force: :cascade do |t|
    t.integer "territorial_authority_id"
    t.integer "contact_list_id"
    t.integer "created_by_id"
    t.integer "updated_by_id"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "suburb"
    t.string "city_town"
    t.string "post_code"
    t.string "ta"
    t.string "pxid"
    t.string "phone"
    t.string "email"
    t.string "title"
    t.boolean "tertiary_student"
    t.string "tertiary_institution"
    t.text "admin_notes"
    t.text "coordinator_notes"
    t.integer "old_subscriber_id"
    t.string "old_system_address"
    t.string "old_system_suburb"
    t.string "old_system_city_town"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.integer "further_contact_requested", default: 0
    t.boolean "bad_address", default: false
    t.string "dpid"
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

  create_table "items", force: :cascade do |t|
    t.string "title", null: false
    t.string "author"
    t.string "code", null: false
    t.string "image_path"
    t.string "description", limit: 1000
    t.datetime "deactivated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items_orders", id: false, force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "order_id"
    t.index ["item_id"], name: "index_items_orders_on_item_id"
    t.index ["order_id"], name: "index_items_orders_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "shipment_id"
    t.text "admin_notes"
    t.text "coordinator_notes"
    t.integer "method_of_discovery"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ip_address", limit: 40
    t.string "session_identifier", limit: 100
    t.integer "method_received"
    t.boolean "duplicate", default: false
    t.integer "created_by_id"
    t.integer "updated_by_id"
    t.integer "customer_id"
    t.bigint "table_id"
    t.index ["created_by_id"], name: "index_orders_on_created_by_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["duplicate"], name: "index_orders_on_duplicate"
    t.index ["shipment_id"], name: "index_orders_on_shipment_id"
    t.index ["table_id"], name: "index_orders_on_table_id"
    t.index ["updated_by_id"], name: "index_orders_on_updated_by_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_shipments_on_created_at"
  end

  create_table "tables", force: :cascade do |t|
    t.string "coordinator_phone"
    t.string "coordinator_email"
    t.text "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "coordinator_first_name"
    t.string "coordinator_last_name"
    t.string "city"
  end

  create_table "territorial_authorities", force: :cascade do |t|
    t.string "name", null: false
    t.integer "code", null: false
    t.string "addressfinder_name", null: false
    t.integer "coordinator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressfinder_name"], name: "index_territorial_authorities_on_addressfinder_name"
    t.index ["coordinator_id"], name: "index_territorial_authorities_on_coordinator_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password", null: false
    t.string "password_salt", null: false
    t.string "persistence_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "name"
    t.index ["admin"], name: "index_users_on_admin"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "orders", "tables"
end
