# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe OrderService do
  describe '.submit' do
    let(:user)     { create :user }
    let(:bank)     { create :bank, name: 'This Bank' }
    let(:product)  { create :product, bank: bank }
    let(:variant)  { create :variant, product: product, rates: [[1, 2.4]] }
    let(:fixation) { 1 }
    let!(:puid)    { [variant.id.to_s, fixation].join('-') }
    let(:rate)     { 2.4 }
    let(:serialized_product)  { SerializedProductService.call(variant) }
    let(:user_maturity)       { 120 }
    let(:user_filter_ids)     { [Filter.find(1).id, Filter.find(2).id] }
    let(:user_loan_size)      { 4_500_000 }
    let(:user_property_value) { 6_650_000 }
    let(:user_selected_property_value) { true }
    let(:user_selected_fixation) { true }
    let(:user_subpurpose)     { Filter.find(1) }
    let(:user_purpose)        { Purpose.find_by(code: :purchase) }
    let(:existing_loan_attributes)  { { rate: 3.1, loan_size: 1, maturity_year: 2019, maturity_month: 1, repayments_left: 222 }.with_indifferent_access }
    let(:user_financial_attributes) { { liabilities_total: 2222, net_monthly_income: 111, liabilities_monthly_repayment: 111 }.with_indifferent_access }
    let(:order_attributes) do
      {
        product_id: puid,
        purpose: user_purpose.code,
        subpurpose_id: user_subpurpose.id,
        property_value: user_property_value,
        user_selected_fixation: user_selected_fixation,
        loan_size: user_loan_size,
        maturity: user_maturity,
        filter_ids: user_filter_ids,
        existing_loan_attributes: existing_loan_attributes,
        user_financial_attributes: user_financial_attributes
      }
    end

    it 'creates order with correct data' do
      expect { OrderService::Order.new(user, order_attributes).save }.to change { Order.count }.by(1)

      order = Order.find_by(user_id: user.id, user_maturity: 120, user_loan_size: 4_500_000)

      expect(order.variant.id).to eq variant.id
      expect(order.product.id).to eq product.id
      expect(order.bank.id).to eq bank.id
      expect(order.user_purpose.id).to eq user_purpose.id
      expect(order.user_subpurpose.id).to eq user_subpurpose.id
      expect(order.fixation).to eq fixation
      expect(order.rate).to eq rate
      expect(order.user_property_value).to eq user_property_value
      expect(order.user_loan_size).to eq user_loan_size
      expect(order.user_maturity).to eq user_maturity
      expect(order.user_filter_ids).to eq user_filter_ids
      expect(order.user_selected_property_value).to eq user_selected_property_value
      expect(order.user_selected_fixation).to eq user_selected_fixation
      expect(order.existing_loan_attributes.with_indifferent_access).to eq existing_loan_attributes
      expect(order.user_financial_attributes.with_indifferent_access).to eq user_financial_attributes
    end
  end
end
