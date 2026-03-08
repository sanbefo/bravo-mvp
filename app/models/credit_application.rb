class CreditApplication < ApplicationRecord

  belongs_to :user
  enum :country, { MX: 0, PT: 1 }
  enum :currency, { mexico: "MXN", portugal: "EUR" }
  enum :status, { pending: 0, under_review: 1, rejected: 2, approved: 3 }

  validates :country, :currency, :full_name, :document_id, :requested_amount, :monthly_income, presence: true
  validate :only_one_pending_application, on: :create
  scope :by_country, ->(country_code) { where(country: country_code) }
  scope :by_status, ->(status) { where(status: status) }

  private

    def only_one_pending_application
      if user.credit_applications.pending.exists?
        errors.add(:base, "You already have a pending credit application")
      end
    end
end
