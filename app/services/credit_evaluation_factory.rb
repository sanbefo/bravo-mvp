class CreditEvaluationFactory
  def self.validator_for(application)
    case application.country.downcase
    when 'mx' then CountryRules::MexicoValidator.new(application)
    when 'pt' then CountryRules::PortugalValidator.new(application)
    else CountryRules::BaseValidator.new(application)
    end
  end
end
