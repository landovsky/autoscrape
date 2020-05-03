# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    voucher  { VoucherGenerator.call }
    user     { create :user }
    bank     { find_or_create :bank, name: 'This Bank' }
    product  { find_or_create :product, bank: bank }
    variant  { find_or_create :variant, product: product, rates: [[1, 2.4]] }
    fixation { 1 }
    rate     { 2.4 }

    serialized_product { SerializedProductService.call(variant) }

    user_maturity       { 120 }
    user_loan_size      { 4_500_000 }
    user_property_value { 6_650_000 }
    user_selected_property_value { true }
    user_selected_fixation { true }
    user_subpurpose     { find_or_create :filter }
    user_purpose        { find_or_create :purpose }
  end
end
