class Transaction < ApplicationRecord
  belongs_to :source_account
  belongs_to :destination_account
end
