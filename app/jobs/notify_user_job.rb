# typed: true
# frozen_string_literal: true

class NotifyUserJob < ApplicationJob
  queue_as :send_notification

  def perform(order)
    return if Rails.env.test?

    Adapter::Order::Email.notify_user(order)
  end
end
