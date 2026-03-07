module BankProviders
  class PortugalProvider < BaseProvider
    def fetch_data
      {
        bank_rating: %w[A B C].sample,
        active_loans: rand(0..3),
        bank: "Banco CR7"
      }
    end
  end
end
