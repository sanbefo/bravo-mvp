module CountryRules
  class MexicoValidator < BaseValidator
    CURP_REGEX = /^[A-Z]{4}\d{6}[A-Z]{6}\d{2}$/

    def validate!
      validate_curp
      validate_income_ratio
    end

    def validate_income_ratio
      return if application.requested_amount > application.monthly_income * 6

      raise "Requested amount exceeds allowed ratio"
    end

    private

    def validate_curp
      raise "Invalid CURP format" unless application.user.document.match?(CURP_REGEX)
    end
  end
end
