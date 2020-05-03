# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :product_condition, traits: [:insurance] do
    trait :hidden do
      hidden { true }
    end

    trait :insurance do
      condition { find_or_create :condition }
    end
  end
end
