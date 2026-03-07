class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :source_account, null: false, foreign_key: { to_table: :accounts }
      t.references :destination_account, null: false, foreign_key: { to_table: :accounts }

      t.integer :amount_cents, null: false
      t.string :currency, null: false

      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
