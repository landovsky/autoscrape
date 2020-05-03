# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :postcode do
    code         { rand(10_000..99_900) }
    municipality { Faker::Address.city }
  end
end
