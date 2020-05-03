# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe IntegrationService do
  context 'Adapter::Order::Email #order_submitted' do
    let(:bank)       { create :bank, code: nil }
    let(:order)      { create :order, bank: bank }
    let(:request)    { IntegrationService.order_submitted(order) }
    let(:email_data) { Adapter::Order::Email::RequestMapper.call order, :bank }
    let(:mock_response) { SendGrid::Response.new(OpenStruct.new(code: 202)) }

    before :each do
      allow(Client::Email).to(
        receive(:send_mail)
          .with(email_data)
          .and_return(mock_response)
      )
    end

    it 'saves request and response' do
      expect { request }.to change { Request.count }.by(1)
      expect(Request.last.adapter).to eq Adapter::Order::Email::ADAPTER_NAME
      expect(Request.last.success).to eq true
    end

    it 'binds request with order' do
      expect { request }.to change { OrderSubmission.count }.by(1)
      expect(order.requests.count).to eq 1
      expect(order.requests.last).to eq Request.find_by(adapter: Adapter::Order::Email::ADAPTER_NAME, success: true)
    end
  end
end
