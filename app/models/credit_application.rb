class CreditApplication < ApplicationRecord

  enum :country, { MX: 0, PT: 1 }

  enum :currency, { mexico: "MXN", portugal: "EUR" }

  enum :status, { pending: 0, under_review: 1, approved: 2, rejected: 3 }

  validates :country, :currency, :full_name, :document_id, :requested_amount, :monthly_income, presence: true

  scope :by_country, ->(country) { where(country: country) }
  scope :by_status, ->(status) { where(status: status) }
end
