# typed: false
# frozen_string_literal: true

ActiveAdmin.register Feature do
  permit_params :title, :valuable
end
