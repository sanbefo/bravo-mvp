module CountryRules
  class PortugalValidator < BaseValidator
    def validate!
      validate_nif
    end

    def validate_income_ratio
      return if application.requested_amount <= application.monthly_income * 5

      raise "Requested amount exceeds allowed ratio"
    end

    private

    def validate_nif
      raise "Invalid NIF format" unless application.document_id.match?(/^\d{9}$/)
    end
  end
end
