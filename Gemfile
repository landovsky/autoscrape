# frozen_string_literal: true

source 'https://rubygems.org'
# git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# ActiveAdmin
gem 'activeadmin', '~> 2.0'
gem 'active_admin-humanized_enum'
gem 'arctic_admin'

# Model / DB
gem 'activerecord-import' # for seeder.rb
gem 'delayed_job_active_record'
gem 'fast_jsonapi', '~> 1.5'
gem 'pg'

# Rails
gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'draper', '~> 3.1'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2.3'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# 3rd party intergrations
gem 'sentry-raven'

group :development, :test do
  # Used for bulk importing seed objects
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
  # gem 'rubocop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara-selenium'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'vcr', '~> 5.0'
  gem 'webdrivers', '~> 4.1', '>= 4.1.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)
