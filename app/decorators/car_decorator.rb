# frozen_string_literal: true

class CarDecorator < ApplicationDecorator
  delegate_all

  def title
    h.link_to object.title, object.url
  end

  def url
    h.link_to 'odkaz', object.url, target: '_blank'
  end

  def price
    price = h.currency object.price, 'Kč'
    return price if car_prices.count <= 1
    h.content_tag :strong, price
  end

  def odometer
    h.currency object.odometer, 'km'
  end

  def manufactured
    object.manufactured&.strftime "%Y/%m"
  end

  def car_status
    object.car_status&.sales_status
  end
end
