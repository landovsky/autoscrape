# typed: true
# frozen_string_literal: true

class SMSServiceError < ApplicationError
  def msg
    fallback_msg = TH.api_error(:sms_service, :other)
    @msg       ||= TH.api_error(:sms_service, options[:gateway_code]&.to_s, fallback: fallback_msg)
  end

  def code
    @code ||= :sending_message_failed
  end

  def level
    :warn
  end
end
