module CountryRules
  class PortugalValidator < BaseValidator
    def validate!
      validate_nif
      validate_income_ratio
    end

    private

    def validate_nif
      raise "Invalid NIF format" unless application.document_id.match?(/^\d{9}$/)
    end

    def validate_income_ratio
      # Exit early if the amount is within a safe limit (less than or equal to 5x)
      return if application.requested_amount <= application.monthly_income * 5

      raise "Requested amount exceeds allowed ratio"
    end
  end
end
