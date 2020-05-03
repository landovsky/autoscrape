# typed: false
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_user
    return current_user_development if Rails.env.development?
    return if session[:userinfo].blank?

    user_email      = session[:userinfo]['email']
    @current_user ||= User.admins.find_by(email: user_email) if user_email.present?
  end

  def current_user_development
    @current_user ||= User.admins.where(email: 'tomas.landovsky@applifting.cz').first || User.admins.first
  end
end
