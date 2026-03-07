class AddUserToCreditApplications < ActiveRecord::Migration[7.1]
  def change
    add_reference :credit_applications, :user, null: false, foreign_key: true
  end
end
