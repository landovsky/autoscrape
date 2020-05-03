# typed: ignore
# frozen_string_literal: true

require 'rails_helper'

describe IntegrationService do
  context 'Adapter::Order::CS #order_submitted' do
    let(:bank)  { create :bank, code: Bank::CS }
    let(:user)  { create :user, full_name: 'Ivánek' }
    let(:order) { create :order, user: user, bank: bank }
    let(:request) do
      VCR.use_cassette('adapter_order_cs_success') do
        IntegrationService.order_submitted(order)
      end
    end

    it 'saves request and response' do
      expect { request }.to change { Request.count }.by(1)
      expect(Request.last.adapter).to eq Adapter::Order::CS::ADAPTER_NAME
      expect(Request.last.success).to eq true
    end

    it 'binds request with order' do
      expect { request }.to change { OrderSubmission.count }.by(1)
      expect(order.requests.count).to eq 1
      expect(order.requests.last).to eq Request.find_by(adapter: Adapter::Order::CS::ADAPTER_NAME, success: true)
    end
  end
end
