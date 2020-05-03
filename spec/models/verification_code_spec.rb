# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe VerificationCode do
  include ActiveSupport::Testing::TimeHelpers

  let(:user)         { create :user }
  let(:another_user) { create :user }
  let(:create_code) { proc { |user, code| VerificationCode.create(user: user, code: code, valid_to: 10.minutes.from_now) } }

  describe 'index verification_codes_unique_code_today_index' do
    it 'ensures code uniqueness within combination of year and day of year' do
      travel_to Time.zone.local(2019, 1, 1) do
        create_code[user, '1']
        expect { create_code[another_user, '1'] }.to raise_error ActiveRecord::RecordNotUnique
      end

      travel_to Time.zone.local(2019, 1, 2) do
        create_code[user, '1']
        expect { create_code[another_user, '1'] }.to raise_error ActiveRecord::RecordNotUnique
      end
    end
  end
end
