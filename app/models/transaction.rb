class Transaction < ApplicationRecord
  belongs_to :source_account, class_name: "Account"
  belongs_to :destination_account, class_name: "Account"

  monetize :amount_cents

  validates :amount_cents, numericality: { greater_than: 0 }
end
