module Transactions
  class Create
    attr_reader :transaction

    def initialize(source_account:, destination_account:, amount:)
      @source_account = source_account
      @destination_account = destination_account
      @amount = amount
    end

    def call
      ActiveRecord::Base.transaction do
        validate_balance!

        @transaction = Transaction.create!(
          source_account: @source_account,
          destination_account: @destination_account,
          amount: @amount,
          currency: @source_account.currency,
          status: "completed"
        )

        @source_account.update!(
          balance_cents: @source_account.balance_cents - @amount.cents
        )

        @destination_account.update!(
          balance_cents: @destination_account.balance_cents + @amount.cents
        )
      end

      success
    rescue StandardError => e
      failure(e.message)
    end

    private

    def validate_balance!
      return if @source_account.balance >= @amount

      raise StandardError, "Insufficient funds"
    end

    def success
      OpenStruct.new(success?: true, transaction: @transaction)
    end

    def failure(error)
      OpenStruct.new(success?: false, error: error)
    end
  end
end
