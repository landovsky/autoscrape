# typed: true
# frozen_string_literal: true

class ConfigurationError < ApplicationError
  def msg
    @msg ||= 'Configuration error'
  end

  def code
    @code ||= :configuration_error
  end
end
