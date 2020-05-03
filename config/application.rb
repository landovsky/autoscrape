# typed: true
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AutoScrape
  DEFAULT_MIN_VALIDITY = DateTime.parse('2000-01-01')
  DEFAULT_MAX_VALIDITY = DateTime.parse('9999-12-31')

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    %w(graphql services lib).each do |dir|
      config.autoload_paths << Rails.root.join(dir).to_path
      config.eager_load_paths << Rails.root.join(dir).to_path
    end

    config.active_job.queue_adapter = :delayed_job

    config.time_zone = 'Europe/Prague'

    if ENV['RAILS_LOG_TO_STDOUT'].present?
      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.level     = Logger.const_get(ENV.fetch('RAILS_LOG_LEVEL', 'warn').upcase)
      logger.formatter = config.log_formatter
      config.logger    = ActiveSupport::TaggedLogging.new(logger)
    end
  end
end
