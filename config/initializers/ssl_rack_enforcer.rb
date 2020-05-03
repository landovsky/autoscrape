# typed: strict
# frozen_string_literal: true

if ENV['RAILS_ENV'] == 'production'
  Rails.application.config.middleware.insert_before ActionDispatch::Cookies, Rack::SslEnforcer
end
