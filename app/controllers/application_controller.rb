# typed: false
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PWD']
  def current_user
    OpenStruct.new(id: 1, name: 'Tomáš', email: 'tomas@tomas.cz')
  end
end
