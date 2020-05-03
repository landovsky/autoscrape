# typed: ignore
# frozen_string_literal: true

require 'database_cleaner'
require 'support/helpers'
require 'support/wait_for_ajax'
require 'support/omniauth_macros'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :faraday
end

RSpec.configure do |config|
  config.include Helpers
  config.include OmniauthMacros
  config.include WaitForAjax, type: :feature

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    Rails.application.load_seed
    Capybara.default_max_wait_time = 5
    Capybara.javascript_driver = :selenium_chrome_headless
  end

  config.before(:each) do |example|
    unless example.metadata[:js]
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  config.after(:each) do |example|
    if example.metadata[:js]
      exceptions = %w(conditions fees filters purposes filter_purposes)
      DatabaseCleaner.clean_with(:truncation, except: exceptions)
    else
      DatabaseCleaner.clean
    end
  end

  config.order = :random

  config.example_status_persistence_file_path = 'spec/examples.txt'
end
