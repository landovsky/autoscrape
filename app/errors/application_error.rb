# typed: true
# frozen_string_literal: true

class ApplicationError < BaseError
  def initialize(*)
    super { |error| Raven.capture_exception error }
  end

  def msg
    Rails.env.production? ? 'Internal error' : @msg
  end

  def code
    @code ||= :internal_error
  end

  def level
    :fatal
  end
end
