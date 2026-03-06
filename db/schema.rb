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

ActiveRecord::Schema[7.1].define(version: 2026_03_06_192500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credit_applications", force: :cascade do |t|
    t.integer "country", null: false
    t.string "full_name", null: false
    t.string "document_id", null: false
    t.decimal "requested_amount", precision: 12, scale: 2, null: false
    t.decimal "monthly_income", precision: 12, scale: 2, null: false
    t.datetime "application_date", null: false
    t.integer "status", default: 0, null: false
    t.jsonb "bank_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_date"], name: "index_credit_applications_on_application_date"
    t.index ["country"], name: "index_credit_applications_on_country"
    t.index ["document_id"], name: "index_credit_applications_on_document_id"
    t.index ["status"], name: "index_credit_applications_on_status"
  end

end
