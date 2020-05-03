# typed: true
# frozen_string_literal: true

class SendSMSJob < ApplicationJob
  queue_as :send_sms

  def perform(to:, body:)
    SMSService.send(to: to, body: body)
  end
end
