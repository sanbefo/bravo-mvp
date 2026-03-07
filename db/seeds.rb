require 'faker'

puts "Generating 100 credit applications..."

CreditApplication.destroy_all
User.destroy_all

100.times do |i|
  # 1. Determine Country First
  country = ["MX", "PT"].sample

  # 2. Create the User
  # We use the country-specific Faker logic for names/usernames
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  user = User.create!(
    first_name: first_name,
    last_name: last_name,
    username: Faker::Internet.username(specifier: "#{first_name} #{last_name}", separators: %w(. _)),
    # Use the document logic you had before
    document: country == "MX" ? Faker::Base.regexify(/[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}/) : Faker::Number.number(digits: 9).to_s,
    slug: Faker::Internet.slug(words: "#{first_name} #{last_name} #{SecureRandom.hex(3)}")
  )

  # 3. Define Country-Specific Logic
  if country == "MX"
    # Mexico: 18-digit CLABE (numbers only)
    bank_details = {
      account_type: "CLABE",
      account_number: Faker::Number.number(digits: 18).to_s,
      bank_name: ["BBVA", "Banorte", "Santander", "Citibanamex"].sample
    }

    app_params = {
      country: "MX",
      currency: "MXN",
      requested_amount: rand(10_000..1_000_000),
      monthly_income: rand(5_000..200_000)
    }
  else
    # Portugal: 21-digit NIB (numbers only)
    # Structure: 4 (Bank) + 4 (Branch) + 11 (Account) + 2 (Check digits)
    bank_details = {
      account_type: "NIB",
      account_number: Faker::Number.number(digits: 21).to_s,
      bank_name: ["Millennium BCP", "CGD", "Novo Banco", "BPI"].sample
    }

    app_params = {
      country: "PT",
      currency: "EUR",
      requested_amount: rand(1_000..100_000),
      monthly_income: rand(800..15_000)
    }
  end

  # 4. Create the Credit Application connected to the User
  user.credit_applications.create!(
    app_params.merge(
      full_name: user.full_name, # Syncing name from user record
      document_id: user.document, # Syncing document from user record
      status: CreditApplication.statuses.keys.sample,
      requested_at: Faker::Time.between(from: 30.days.ago, to: Time.current),
      bank_data: bank_details # This goes into your JSONB column
    )
  )
end

puts "Success!"
puts "Created #{User.count} Users."
puts "Created #{CreditApplication.count} Credit Applications."
