class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :source_account, null: false, foreign_key: true
      t.references :destination_account, null: false, foreign_key: true
      t.integer :amount
      t.string :currency
      t.string :status

      t.timestamps
    end
  end
end
