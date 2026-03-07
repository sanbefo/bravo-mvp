module Accounts
  module Validators
    class PortugalValidator < BaseValidator
      NIB_LENGTH = 21
      NIB_REGEX = /\A\d{#{NIB_LENGTH}}\z/

      def valid?
        account_number.match?(NIB_REGEX)
      end
    end
  end
end
