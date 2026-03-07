require 'faker'

puts "Cleaning up old applications..."
CreditApplication.destroy_all

puts "Generating 100 credit applications..."

100.times do |i|
  # Randomly choose between MX and PT
  country = ["MX", "PT"].sample

  if country == "MX"
    # Mexico Logic
    params = {
      country: "MX",
      currency: "MXN",
      # Generates a pseudo-valid CURP: 4 letters, 6 digits, 6 letters, 2 digits
      document_id: "#{Faker::Base.regexify(/[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}/)}",
      full_name: Faker::Name.name_with_middle,
      requested_amount: rand(10_000..1_000_000),
      monthly_income: rand(5_000..200_000)
    }
  else
    # Portugal Logic
    params = {
      country: "PT",
      currency: "EUR",
      # Generates a 9-digit NIF (Tax ID)
      document_id: Faker::Number.number(digits: 9).to_s,
      full_name: Faker::Name.name_with_middle,
      requested_amount: rand(1_000..100_000),
      monthly_income: rand(800..15_000)
    }
  end

  CreditApplication.create!(
    params.merge(
      status: CreditApplication.statuses.keys.sample,
      requested_at: Faker::Time.between(from: 30.days.ago, to: Time.current)
    )
  )
end

puts "Done! Created #{CreditApplication.count} applications."
