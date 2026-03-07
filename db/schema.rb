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

ActiveRecord::Schema[7.1].define(version: 2026_03_07_152036) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "bank_name", null: false
    t.string "account_number", null: false
    t.string "country", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "balance_cents"
    t.string "currency"
    t.index ["account_number"], name: "index_accounts_on_account_number", unique: true
    t.index ["slug"], name: "index_accounts_on_slug", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "credit_applications", force: :cascade do |t|
    t.integer "country", null: false
    t.string "full_name", null: false
    t.string "document_id", null: false
    t.decimal "requested_amount", precision: 12, scale: 2, null: false
    t.decimal "monthly_income", precision: 12, scale: 2, null: false
    t.string "currency", null: false
    t.datetime "requested_at", null: false
    t.integer "status", default: 0, null: false
    t.jsonb "bank_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country"], name: "index_credit_applications_on_country"
    t.index ["document_id"], name: "index_credit_applications_on_document_id"
    t.index ["requested_at"], name: "index_credit_applications_on_requested_at"
    t.index ["status"], name: "index_credit_applications_on_status"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "source_account_id", null: false
    t.bigint "destination_account_id", null: false
    t.integer "amount_cents", null: false
    t.string "currency", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_account_id"], name: "index_transactions_on_destination_account_id"
    t.index ["source_account_id"], name: "index_transactions_on_source_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "username"
    t.string "document", null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "transactions", "accounts", column: "destination_account_id"
  add_foreign_key "transactions", "accounts", column: "source_account_id"
end
