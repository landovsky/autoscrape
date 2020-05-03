# typed: true
# frozen_string_literal: true

module OmniauthMacros
  def mock_valid_auth_hash(user)
    OmniAuth.config.test_mode = true
    opts = {
      'info': {
        'email': user.email,
        'first_name': user.name.split(' ').first,
        'last_name': user.name.split(' ').last
      },
      'credentials': {
        'token': 'XKLjnkKJj7hkHKJkk',
        'expires': true,
        'id_token': 'eyJ0eXAiOiJK1VveHkwaTFBNXdTek41dXAiL.Wz8bwniRJLQ4Fqx_omnGDCX1vrhHjzw',
        'token_type': 'Bearer'
      }
    }
    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new(opts)
  end

  def mock_invalid_auth_hash
    OmniAuth.config.mock_auth[:auth0] = :invalid_credentials
  end
end
