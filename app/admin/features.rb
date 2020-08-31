# typed: false
# frozen_string_literal: true

ActiveAdmin.register Feature do
  permit_params :title, :valuable, :unified_feature_id, :company
end
