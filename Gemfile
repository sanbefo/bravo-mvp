source "https://rubygems.org"
ruby "3.3.0"
gem "connection_pool", "< 3.0"

# --- CORE ---
gem "rails", "~> 7.1.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# --- FRONTEND & ASSETS ---
gem "sprockets-rails"
gem "jsbundling-rails"
gem "cssbundling-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "haml-rails"

# --- AUTHENTICATION & AUTHORIZATION ---
gem "devise"
gem "pundit"
gem "bcrypt", "~> 3.1.7"

# --- BUSINESS LOGIC & DATA ---
gem "money-rails"
gem "sidekiq"
gem "redis", ">= 4.0.1"

# --- SHARED DEVELOPMENT/TEST ---
group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "dotenv-rails"
  gem "faker"
  gem "pry-rails"
end

# --- DEVELOPMENT ONLY ---
group :development do
  gem "annotate"
  gem "web-console"
end

# --- TEST ONLY ---
group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# --- PLATFORM SPECIFIC ---
gem "tzinfo-data", platforms: %i[ windows jruby ]
