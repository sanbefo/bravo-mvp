require "ostruct"

module Accounts
  class Create
    attr_reader :account

    def initialize(user:, params:)
      @user = user
      @params = params
    end

    def call
      @account = @user.accounts.new(@params)

      if @account.save
        success
      else
        failure
      end
    end

    private

    def success
      OpenStruct.new(success?: true, account: @account)
    end

    def failure
      OpenStruct.new(success?: false, errors: @account.errors.full_messages)
    end
  end
end
