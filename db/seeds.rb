require 'faker'

puts "Generating 100 credit applications..."

CreditApplication.destroy_all
User.destroy_all
Rails.cache.clear

user = User.create!(
  first_name: "Santiago",
  last_name: "Bermudez",
  username: "sanbefo",
  document: country = Faker::Base.regexify(/[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}/),
  slug: Faker::Internet.slug(words: "Santiago Bermudez #{SecureRandom.hex(3)}"),
  email: "santiago@bravo.com",
  password: "muybravo",
  role: :admin
)
allowed_domains = ['gmail.com', 'yahoo.com', 'outlook.com', 'icloud.com']

100.times do |i|
  country = ["MX", "PT"].sample
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  random_domain = allowed_domains.sample
  document = country == "MX" ? Faker::Base.regexify(/[A-Z]{4}[0-9]{6}[A-Z]{6}[0-9]{2}/) : Faker::Number.number(digits: 9).to_s
  document = document.chop if rand < 0.1
  user = User.create!(
    first_name: first_name,
    last_name: last_name,
    username: Faker::Internet.username(specifier: "#{first_name} #{last_name}", separators: %w(. _)),
    document: document,
    slug: Faker::Internet.slug(words: "#{first_name} #{last_name} #{SecureRandom.hex(3)}"),
    email: Faker::Internet.email(name: first_name + " " + last_name, domain: random_domain),
    password: Faker::Internet.password
  )

  if country == "MX"
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

  user.credit_applications.create!(
    app_params.merge(
      full_name: user.full_name,
      document_id: user.document,
      status: :pending,
      requested_at: Faker::Time.between(from: 30.days.ago, to: Time.current),
      bank_data: bank_details
    )
  )
end

puts "Success!"
puts "Created #{User.count} Users."
puts "Created #{CreditApplication.count} Credit Applications."
