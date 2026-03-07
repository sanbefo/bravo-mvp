module Accounts
  module Validators
    class BaseValidator
      def initialize(account_number)
        @account_number = account_number
      end

      def valid?
        raise NotImplementedError
      end

      private

      attr_reader :account_number
    end
  end
end
