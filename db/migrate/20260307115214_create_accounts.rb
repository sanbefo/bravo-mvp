class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :bank_name, null: false
      t.string :account_number, null: false
      t.string :country, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :accounts, :slug, unique: true
    add_index :accounts, :account_number, unique: true
  end
end
