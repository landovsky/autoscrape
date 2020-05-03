# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe UserService do
  let(:user)        { create :user }
  let(:create_code) { proc { UserService.request_verification_code(user) } }

  describe '.update' do
    context 'email' do
      let(:user_without_email) { create :user, email: nil, email_confirmed: true }

      it 'updates email if user does not have one (like from Facebook phone registration)' do
        expect { UserService.update(user_without_email, email: 'ahoj@ahoj.cz') }
          .to(change { user_without_email.email }.to('ahoj@ahoj.cz'))
      end

      it 'sets email_confirmed to false for updating email in this way' do
        UserService.update(user_without_email, email: 'ahoj@ahoj.cz')

        expect(user_without_email.reload.email_confirmed).to eq false
      end

      it 'does not update email if user already has email' do
        UserService.update(user, email: 'ahoj@ahoj.cz')

        expect(user.reload.email).not_to eq 'ahoj@ahoj.cz'
      end
    end

    context 'phone' do
      let(:user_with_phone) { create :user, phone_country_code: '+420', phone_number: '712 384 719', phone_confirmed: true }

      it 'unsets phone_confirmed when phone is updated' do
        expect(user_with_phone.phone_confirmed).to eq true

        UserService.update(user_with_phone, phone_number: '712 384 000')
        expect(user_with_phone.reload.phone_confirmed).to eq false
      end
    end
  end

  describe '.request_verification_code' do
    it 'creates verification code record' do
      expect { create_code.call }.to change { VerificationCode.where(user_id: user.id).count }.by(1)
    end

    it 'limits rate at which codes can be generated for a user' do
      ENV['VERIFICATION_CODE_RATE_SEC'] = 1.to_s

      create_code.call
      expect { create_code.call }.to raise_error RateLimitBreachedError
    end
  end

  describe '.submit_verification_code' do
    let(:verify_code)  { proc { |user, code| UserService.submit_verification_code(user, code: code) } }
    let(:another_user) { create :user }

    context 'unsuccessful verification' do
      it 'raises error for expired code' do
        code = create(:verification_code, :expired, user: user).code
        expect { verify_code[user, code] }.to raise_error(ResourceError, /kód již expiroval/)
      end

      it 'raises error for code that does not match database record' do
        code = '0'
        expect { verify_code[user, code] }.to raise_error(ResourceError, 'neplatný kód')
      end

      it 'raises error for code that does not match user' do
        code = create(:verification_code, user: user).code
        expect { verify_code[another_user, code] }.to raise_error(ResourceError, 'neplatný kód')
      end
    end

    context 'successful verification' do
      let(:code) { create(:verification_code, user: user) }

      it 'marks the code as claimed' do
        verify_code[user, code.code]

        expect(code.reload.claimed?).to be true
      end

      it 'returns User object with verified phone' do
        expect(user.phone_confirmed).to eq false
        verified_user = verify_code[user, code.code]

        expect(verified_user).to be_a User
        expect(verified_user.id).to eq user.id
        expect(verified_user.phone_confirmed).to eq true
      end
    end
  end
end
