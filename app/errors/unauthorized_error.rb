# typed: true
# frozen_string_literal: true

class UnauthorizedError < AuthError
  def msg
    @msg ||= TH.api_error(:auth, :unauthorized)
  end

  def code
    @code ||= :unauthorized
  end
end
