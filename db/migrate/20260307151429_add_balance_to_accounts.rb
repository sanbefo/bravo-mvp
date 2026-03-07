class AddBalanceToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :balance_cents, :integer
    add_column :accounts, :currency, :string
  end
end
