# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :product_rate do
    fixation { 1 }
    rate     { 2.3 }

    trait :hidden do
      hidden { true }
    end
  end
end
