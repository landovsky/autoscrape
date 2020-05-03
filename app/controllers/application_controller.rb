# typed: false
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_user
    OpenStruct.new(id: 1, name: 'Tomáš', email: 'tomas@tomas.cz')
  end
end
