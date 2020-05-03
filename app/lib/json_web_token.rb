# typed: false
# frozen_string_literal: true

require 'net/http'
require 'uri'

class JsonWebToken
  def self.verify(token, secret = nil, verify_signature = true, options = {})
    decoded = JWT.decode(token, secret,
                         verify_signature,
                         options_for_decode(options)) do |header|
      jwks_hash[header['kid']]
    end
    decoded[0]
  end

  def self.options_for_decode(options)
    {
      algorithm: options.fetch(:algorithm, 'RS256'),
      verify_expiration: options.fetch(:verify_expiration, true),
      iss: 'https://' + ENV['AUTH0_API_DOMAIN'] + '/',
      verify_iss: options.fetch(:verify_iss, true),
      aud: ENV['AUTH0_API_AUDIENCE'],
      verify_aud: options.fetch(:verify_aud, true)
    }
  end

  def self.jwks_hash(signature = ENV['AUTH0_PUBLIC_KEY'])
    raise JWT::DecodeError, 'Issuer signature not found' if signature.blank?

    jwks_keys = Array(JSON.parse(signature)['keys'])
    Hash[
      jwks_keys.map do |k|
        [k['kid'],
         OpenSSL::X509::Certificate.new(Base64.decode64(k['x5c'].first))
                                   .public_key]
      end
    ]
  end
end
