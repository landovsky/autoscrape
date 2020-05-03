# typed: true
# frozen_string_literal: true

class RateLimitBreachedError < ResourceError
  def msg
    @msg ||= 'Rate limit breached.'
  end

  def code
    @code ||= :too_many_requests
  end
end
