# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170429022115) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cancelled_order_events", force: true do |t|
    t.integer  "cancelled_by_id"
    t.integer  "customer_id"
    t.text     "order_details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cancelled_order_events", ["cancelled_by_id"], name: "index_cancelled_order_events_on_cancelled_by_id", using: :btree
  add_index "cancelled_order_events", ["customer_id"], name: "index_cancelled_order_events_on_customer_id", using: :btree

  create_table "contact_lists", force: true do |t|
    t.integer  "territorial_authority_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_lists", ["territorial_authority_id"], name: "index_contact_lists_on_territorial_authority_id", using: :btree

  create_table "customers", force: true do |t|
    t.integer  "territorial_authority_id"
    t.integer  "contact_list_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "suburb"
    t.string   "city_town"
    t.string   "post_code"
    t.string   "ta"
    t.string   "pxid"
    t.string   "phone"
    t.string   "email"
    t.string   "title"
    t.boolean  "tertiary_student"
    t.string   "tertiary_institution"
    t.text     "admin_notes"
    t.text     "coordinator_notes"
    t.integer  "old_subscriber_id"
    t.string   "old_system_address"
    t.string   "old_system_suburb"
    t.string   "old_system_city_town"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "further_contact_requested",                          default: 0
    t.boolean  "bad_address",                                        default: false
    t.string   "dpid"
    t.decimal  "x",                         precision: 10, scale: 6
    t.decimal  "y",                         precision: 10, scale: 6
  end

  add_index "customers", ["address"], name: "index_customers_on_address", using: :btree
  add_index "customers", ["city_town"], name: "index_customers_on_city_town", using: :btree
  add_index "customers", ["contact_list_id"], name: "index_customers_on_contact_list_id", using: :btree
  add_index "customers", ["created_by_id"], name: "index_customers_on_created_by_id", using: :btree
  add_index "customers", ["email"], name: "index_customers_on_email", using: :btree
  add_index "customers", ["first_name"], name: "index_customers_on_first_name", using: :btree
  add_index "customers", ["further_contact_requested"], name: "index_customers_on_further_contact_requested", using: :btree
  add_index "customers", ["last_name"], name: "index_customers_on_last_name", using: :btree
  add_index "customers", ["parent_id"], name: "index_customers_on_parent_id", using: :btree
  add_index "customers", ["phone"], name: "index_customers_on_phone", using: :btree
  add_index "customers", ["suburb"], name: "index_customers_on_suburb", using: :btree
  add_index "customers", ["territorial_authority_id"], name: "index_customers_on_territorial_authority_id", using: :btree
  add_index "customers", ["updated_by_id"], name: "index_customers_on_updated_by_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "title",                       null: false
    t.string   "author"
    t.string   "code",                        null: false
    t.string   "image_path"
    t.string   "description",    limit: 1000
    t.datetime "deactivated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items_orders", id: false, force: true do |t|
    t.integer "item_id"
    t.integer "order_id"
  end

  add_index "items_orders", ["item_id"], name: "index_items_orders_on_item_id", using: :btree
  add_index "items_orders", ["order_id"], name: "index_items_orders_on_order_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "shipment_id"
    t.text     "admin_notes"
    t.text     "coordinator_notes"
    t.integer  "method_of_discovery"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_address",           limit: 40
    t.string   "session_identifier",   limit: 100
    t.integer  "method_received"
    t.boolean  "duplicate",                        default: false
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "customer_id"
    t.integer  "table_id"
    t.boolean  "shipped_before_order",             default: false
  end

  add_index "orders", ["created_by_id"], name: "index_orders_on_created_by_id", using: :btree
  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  add_index "orders", ["duplicate"], name: "index_orders_on_duplicate", using: :btree
  add_index "orders", ["shipment_id"], name: "index_orders_on_shipment_id", using: :btree
  add_index "orders", ["updated_by_id"], name: "index_orders_on_updated_by_id", using: :btree

  create_table "shipments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipments", ["created_at"], name: "index_shipments_on_created_at", using: :btree

  create_table "tables", force: true do |t|
    t.string   "coordinator_phone"
    t.string   "coordinator_email"
    t.text     "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "coordinator_first_name"
    t.string   "coordinator_last_name"
  end

  create_table "territorial_authorities", force: true do |t|
    t.string   "name",               null: false
    t.integer  "code",               null: false
    t.string   "addressfinder_name", null: false
    t.integer  "coordinator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "territorial_authorities", ["addressfinder_name"], name: "index_territorial_authorities_on_addressfinder_name", using: :btree
  add_index "territorial_authorities", ["coordinator_id"], name: "index_territorial_authorities_on_coordinator_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             null: false
    t.string   "crypted_password",                  null: false
    t.string   "password_salt",                     null: false
    t.string   "persistence_token",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",             default: false
    t.string   "name"
  end

  add_index "users", ["admin"], name: "index_users_on_admin", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
