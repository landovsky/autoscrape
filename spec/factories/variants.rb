# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :variant do
    transient do
      rates { [] }
    end
    product       { find_or_create :product }
    ltv_max       { 80 }
    maturity_min  { 1 }
    maturity_max  { 30 }
    loan_size_min { 500_000 }
    loan_size_max { 10_000_000 }

    valid_from    { product.valid_from }
    valid_to      { product.valid_to }

    product_rates do
      rates.map do |rate|
        ProductRate.new(fixation: rate[0], rate: rate[1])
      end
    end

    trait :discounted do
      unlisted_discount { 0.3 }
    end

    trait :with_conditions do
      after :create do |variant|
        create :product_condition, variant: variant
      end
    end

    trait :with_rates do
      transient do
        rates { [[1, 2.3], [2, 2.8], [3, 3], [5, 3.1], [8, 3.3], [10, 3.5]] }
      end
    end

    factory :variant_complete, traits: %i(with_conditions with_rates)
  end
end
