class Account < ApplicationRecord
  extend FriendlyId

  friendly_id :account_number, use: :slugged

  belongs_to :user

  VALID_COUNTRIES = %w[MX PT].freeze
  VALID_BANKS = ["Banco CH14", "Banco CR7"].freeze

  validates :bank_name, presence: true, inclusion: { in: VALID_BANKS }
  validates :account_number, presence: true, uniqueness: true
  validates :country, presence: true, inclusion: { in: VALID_COUNTRIES }
  validate :account_number_format

  private

  def account_number_format
    validator = case country
                when "MX"
                  Accounts::Validators::MexicoValidator.new(account_number)
                when "PT"
                  Accounts::Validators::PortugalValidator.new(account_number)
                end

    return if validator&.valid?

    errors.add(:account_number, "invalid for country #{country}")
  end
end
