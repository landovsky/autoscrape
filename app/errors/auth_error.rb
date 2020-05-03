# typed: true
# frozen_string_literal: true

class AuthError < BaseError
  def msg
    @msg ||= 'Authentication failed'
  end

  def code
    @code ||= :authentication_failed
  end

  def self.wrap(error)
    new(nil, error: error, reason: error.message)
  end
end
