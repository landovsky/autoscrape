# typed: false
# frozen_string_literal: true

module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |e|
      render json: apollo_friendly(ApplicationError.wrap(e).to_json)
    end

    rescue_from ResourceError, AuthError, SMSServiceError do |e|
      render json: apollo_friendly(e.to_json)
    end

    rescue_from JWT::DecodeError do |e|
      render json: apollo_friendly(AuthError.wrap(e).to_json)
    end

    def apollo_friendly(error)
      {
        errors: [error],
        data: []
      }
    end
  end
end
