# typed: strict
# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get '/logout', to: 'application_controller#logout', as: :logout
end
