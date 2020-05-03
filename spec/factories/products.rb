# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    transient do
      purpose_list              { ['bez účelu', 'budoucí koupě'] }
      default_unlisted_discount { nil }
    end

    bank             { find_or_create :bank, unlisted_discount: default_unlisted_discount }
    name             { 'Hypotéka na družstevní byt' }
    days_to_approval { 5 }
    eletronic_submission { true }

    valid_from       { 10.years.ago.beginning_of_hour }
    valid_to         { 10.years.from_now.beginning_of_hour }

    purposes do
      purpose_list.map do |p|
        Purpose.find_by(name: p)
      end
    end

    after :create do |product|
      create(:product_purpose, product: product)
    end

    trait :with_base_variant do
      after :create do |product|
        create :variant_complete, :discounted, product: product
      end
    end

    trait :with_documents do
      after :create do |product|
        product.product_documents << ProductDocument.new(document: Document.first)
        product.product_documents << ProductDocument.new(document: Document.last)
      end
    end

    trait :with_features do
      after :create do |product|
        product.product_features << ProductFeature.new(feature: Feature.first)
        product.product_features << ProductFeature.new(feature: Feature.last)
      end
    end

    trait :with_fees do
      after :create do |product|
        product.product_fees << ProductFee.new(fee: Fee.first, amount: 300)
        product.product_fees << ProductFee.new(fee: Fee.last, amount: 2500)
      end
    end

    trait :with_filters do
      after :create do |product|
        Filter.all.each do |filter|
          product.product_filters << ProductFilter.new(filter: filter)
        end
      end
    end

    factory :product_complete, traits: %i(with_documents with_features with_fees with_filters with_base_variant)
  end
end
