# typed: true
# frozen_string_literal: true

class NotFoundError < ResourceError
  def msg
    @msg ||= 'Resource not found'
  end

  def code
    @code ||= :resource_not_found
  end
end
