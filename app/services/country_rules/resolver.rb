module CountryRules
  class Resolver

    def self.for(application)
      case application.country
      when "mexico"
        MexicoValidator.new(application)
      when "portugal"
        PortugalValidator.new(application)
      else
        raise "Unsupported country"
      end
    end

  end
end
