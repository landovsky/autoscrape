# typed: true
# frozen_string_literal: true

class NotifyBankJob < ApplicationJob
  queue_as :send_notification

  def perform(order)
    return if Rails.env.test?

    IntegrationService.order_submitted(order)
  end
end
