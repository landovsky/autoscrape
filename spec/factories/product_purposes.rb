# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :product_purpose do
    purpose { find_or_create :purpose }
  end
end
