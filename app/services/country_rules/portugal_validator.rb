module CountryRules
  class PortugalValidator < BaseValidator

    def validate!
      validate_nif
      validate_income_ratio
    end

    private

    def validate_nif
      unless application.document_id.match?(/^\d{9}$/)
        raise "Invalid NIF format"
      end
    end

    def validate_income_ratio
      if application.requested_amount > application.monthly_income * 5
        raise "Requested amount exceeds allowed ratio"
      end
    end

  end
end
