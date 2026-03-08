source "https://rubygems.org"
ruby "3.3.0"
gem "connection_pool", "< 3.0"

# --- CORE ---
gem "bootsnap", require: false
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3"
gem 'schema_to_dbml'

# --- FRONTEND & ASSETS ---
gem "cssbundling-rails"
gem 'friendly_id'
gem "haml-rails"
gem "jbuilder"
gem "jsbundling-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

# --- AUTHENTICATION & AUTHORIZATION ---
gem "bcrypt", "~> 3.1.7"
gem "devise"
gem "pundit"

# --- BUSINESS LOGIC & DATA ---
gem "money-rails"
gem "redis", ">= 4.0.1"
gem "sidekiq"

# --- SHARED DEVELOPMENT/TEST ---
group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "dotenv-rails"
  gem "faker"
  gem "pry-rails"
end

# --- DEVELOPMENT ONLY ---
group :development do
  gem "annotate"
  gem "rails-erd"
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem "web-console"
end

# --- TEST ONLY ---
group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# --- PLATFORM SPECIFIC ---
gem "tzinfo-data", platforms: %i[windows jruby]

gem "tailwindcss-rails", "~> 4.4"

gem "devise-jwt", "~> 0.13.0"
