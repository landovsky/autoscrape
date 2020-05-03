# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      name { Faker::Name.name }
    end
    full_name { name }
    email     { Faker::Internet.email }
    postcode  { create(:postcode).code }

    phone_country_code      { '+420' }
    sequence(:phone_number) { |n| '7'.ljust(9 - n.to_s.size, '0') + n.to_s }

    sequence(:auth0_user_id) { |n| "fake-auth0-id-#{n}" }

    trait :admin do
      admin_user { true }
    end
  end
end
