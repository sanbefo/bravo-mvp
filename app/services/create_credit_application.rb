class CreateCreditApplication
  def initialize(params)
    @params = params
  end

  def call
    application = CreditApplication.new(filtered_params)
    application.application_date = Time.current
    application.status = :pending
    # here we validate depending on the country the client is from
    validate_country_rules(application)
    # here we validate depending on the bank the client uses
    fetch_bank_data(application)
    application.save!
    application
  end

  private

  attr_reader :params

  def filtered_params
    params.slice(
      :country,
      :full_name,
      :document_id,
      :requested_amount,
      :monthly_income
    )
  end

  def validate_country_rules(application)
    validator = CountryRules::Resolver.for(application)
    validator.validate!
  end

  def fetch_bank_data(application)
    provider = BankProviders::Resolver.for(application)
    application.bank_data = provider.fetch_data
  end
end
