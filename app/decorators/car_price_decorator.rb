# frozen_string_literal: true

class CarPriceDecorator < ApplicationDecorator
  decorates_association :car_prices
  delegate_all

  def price
    h.currency object.price, 'Kč'
  end

  def change
    return unless object.previous_price&.price

    h.currency (object.price - object.previous_price&.price), 'Kč'
  end
end
