# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe JsonWebToken do
  include ActiveSupport::Testing::TimeHelpers

  describe '.verify' do
    let(:mount)        { proc { |token_type| File.read("spec/fixtures/jwt/jwt_#{token_type}") } }
    let(:verification) { proc { JsonWebToken.verify mount[:valid_auth0_token] } }

    before(:all) do
      ENV['AUTH0_API_AUDIENCE'] = 'Bw6rF3FlcPaFqa3ZIkuNzrSWFomhMX6Y'
      ENV['AUTH0_API_DOMAIN']   = 'staging-moje-hyposka.eu.auth0.com'
      ENV['AUTH0_PUBLIC_KEY']   = File.read('spec/fixtures/jwt/jwt_issuer_signature')
    end

    before(:each) { travel_to Time.zone.local(2019, 7, 8) }

    after(:each) { travel_back }

    it 'returns decoded payload' do
      decoded = verification.call

      expect(decoded).to be_a Hash
      expect(decoded['nickname']).to eq 'tomas.landovsky'
    end

    context 'validation' do
      it 'raises an error for unreadable token' do
        verification = proc { JsonWebToken.verify mount[:invalid_auth0_token] }
        expect { verification.call }.to raise_error(JWT::DecodeError, /Invalid segment encoding/)
      end

      context "issuer's signature" do
        it 'raises exception when signature is not found' do
          ENV['AUTH0_PUBLIC_KEY'] = nil

          expect { verification.call }.to raise_error(JWT::DecodeError, /Issuer signature not found/)

          ENV['AUTH0_PUBLIC_KEY'] = File.read('spec/fixtures/jwt/jwt_issuer_signature')
        end

        it "validates issuer's signature" do
          expect(verification.call['nickname']).to eq 'tomas.landovsky'
        end
      end

      context 'expiry' do
        it 'validates expiration time in future' do
          travel_back

          travel_to Time.zone.local(2020, 7, 8) do
            expect { verification.call(:valid_auth0_token) }.to raise_error(JWT::ExpiredSignature, /Signature has expired/)
          end
        end
      end
    end
  end
end
