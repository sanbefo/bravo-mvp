module Accounts
  module Validators
    class MexicoValidator < BaseValidator
      CLABE_LENGTH = 18
      CLABE_REGEX = /\A\d{#{CLABE_LENGTH}}\z/

      def valid?
        account_number.match?(CLABE_REGEX)
      end
    end
  end
end
