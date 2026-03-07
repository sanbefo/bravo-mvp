module BankProviders
  class MexicoProvider < BaseProvider
    def fetch_data
      {
        credit_score: rand(500..750),
        debts: rand(0..5000),
        bank: "Banco CH14"
      }
    end
  end
end
