# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :bank do
    name                     { 'Moje Banka' }
    order_notification_email { Faker::Internet.email }
    code                     { ::Bank::CS }
  end
end
