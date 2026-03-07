module BankProviders
  class BaseProvider
    def initialize(application)
      @application = application
    end

    def fetch_data
      raise NotImplementedError
    end

    private

    attr_reader :application
  end
end
