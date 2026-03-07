module BankProviders
  class Resolver
    def self.for(application)
      case application.country
      when "mexico"
        MexicoProvider.new(application)
      when "portugal"
        PortugalProvider.new(application)
      else
        raise "Unsupported country"
      end
    end
  end
end
