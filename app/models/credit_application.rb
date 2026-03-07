class CreditApplication < ApplicationRecord
  # The "Gold Standard" for Rails 7 + RuboCop
  enum :country, { mexico: 0, portugal: 1 }

  enum :status, {
    pending: 0,
    under_review: 1,
    approved: 2,
    rejected: 3
  }
end
