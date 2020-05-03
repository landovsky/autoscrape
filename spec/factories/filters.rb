# typed: false
# frozen_string_literal: true

FactoryBot.define do
  factory :filter do
    transient do
      purpose_list { %w(other future_purchase) }
    end

    name { 'OSVČ' }

    purposes do
      purpose_list.map do |p|
        Purpose.find_by(code: p)
      end
    end
  end
end
