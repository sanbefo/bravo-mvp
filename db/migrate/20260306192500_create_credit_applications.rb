class CreateCreditApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :credit_applications do |t|
      t.integer :country, null: false
      t.string :full_name, null: false
      t.string :document_id, null: false

      t.decimal :requested_amount, precision: 12, scale: 2, null: false
      t.decimal :monthly_income, precision: 12, scale: 2, null: false
      t.string :currency, null: false
      t.datetime :requested_at, null: false
      t.integer :status, null: false, default: 0

      t.jsonb :bank_data, default: {}

      t.timestamps
    end

    add_index :credit_applications, :country
    add_index :credit_applications, :status
    add_index :credit_applications, :requested_at
    add_index :credit_applications, :document_id
  end
end
