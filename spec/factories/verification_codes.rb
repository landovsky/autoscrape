# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :verification_code do
    user     { create :user }
    code     { VerificationCode.generate }
    valid_to { 10.minutes.from_now }

    trait :expired do
      valid_to { 10.minutes.ago }
    end
  end
end
