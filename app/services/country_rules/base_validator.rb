module CountryRules
  class BaseValidator
    def initialize(application)
      @application = application
    end

    def validate!
      raise NotImplementedError
    end

    private

    attr_reader :application
  end
end
