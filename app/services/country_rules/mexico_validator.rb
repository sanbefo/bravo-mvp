module CountryRules
  class MexicoValidator < BaseValidator

    CURP_REGEX = /^[A-Z]{4}\d{6}[A-Z]{6}\d{2}$/

    def validate!
      validate_curp
      validate_income_ratio
    end

    private

    def validate_curp
      unless application.document_id.match?(CURP_REGEX)
        raise "Invalid CURP format"
      end
    end

    def validate_income_ratio
      if application.requested_amount > application.monthly_income * 6
        raise "Requested amount exceeds allowed ratio"
      end
    end

  end
end
