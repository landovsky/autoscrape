# frozen_string_literal: true

class CarDecorator < ApplicationDecorator
  delegate_all

  def title
    h.link_to object.title, object.url
  end

  def url
    h.link_to 'odkaz', object.url, target: '_blank'
  end

  def manufactured
    object.manufactured.strftime "%Y/%m"
  end

  def car_status
    object.car_status&.sales_status
  end
end
