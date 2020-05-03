# typed: false
# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'pry'
require 'vcr'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'factory_bot'

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Time.zone = 'Europe/Prague'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.register_strategy(:find_or_create, FactoryBot::Strategy::FindOrCreate)
FactoryBot.allow_class_lookup = false
