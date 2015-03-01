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

ActiveRecord::Schema.define(version: 20150301054228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "orders", force: true do |t|
    t.integer  "historical_subscriber_id"
    t.integer  "shipment_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "suburb"
    t.string   "city_town"
    t.string   "phone"
    t.string   "email"
    t.text     "admin_notes"
    t.text     "coordinator_notes"
    t.integer  "method_of_discovery"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                     limit: 10
    t.string   "ip_address",                limit: 40
    t.string   "session_identifier",        limit: 100
    t.string   "ta",                        limit: 100
    t.string   "pxid",                      limit: 50
    t.integer  "post_code"
    t.integer  "method_received"
    t.boolean  "tertiary_student",                      default: false
    t.string   "tertiary_institution"
    t.boolean  "duplicate",                             default: false
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "further_contact_requested",             default: false
  end

  add_index "orders", ["address"], name: "index_orders_on_address", using: :btree
  add_index "orders", ["city_town"], name: "index_orders_on_city_town", using: :btree
  add_index "orders", ["created_by_id"], name: "index_orders_on_created_by_id", using: :btree
  add_index "orders", ["duplicate"], name: "index_orders_on_duplicate", using: :btree
  add_index "orders", ["email"], name: "index_orders_on_email", using: :btree
  add_index "orders", ["first_name"], name: "index_orders_on_first_name", using: :btree
  add_index "orders", ["last_name"], name: "index_orders_on_last_name", using: :btree
  add_index "orders", ["phone"], name: "index_orders_on_phone", using: :btree
  add_index "orders", ["shipment_id"], name: "index_orders_on_shipment_id", using: :btree
  add_index "orders", ["suburb"], name: "index_orders_on_suburb", using: :btree
  add_index "orders", ["updated_by_id"], name: "index_orders_on_updated_by_id", using: :btree

  create_table "shipments", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipments", ["created_at"], name: "index_shipments_on_created_at", using: :btree

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
