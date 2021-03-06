# frozen_string_literal: true

class CarDecorator < ApplicationDecorator
  delegate_all

  def title
    object.title
  end

  def title_link
    h.link_to object.title, object.url, target: '_blank'
  end

  def url
    h.link_to 'odkaz', object.url, target: '_blank'
  end

  def price
    h.currency object.price, 'Kč'
  end

  def discount
    return if car_prices.count <= 1

    h.currency object.car_prices.last.price - object.car_prices.first.price, 'Kč'
  end

  def odometer
    h.currency object.odometer, 'km'
  end

  def manufactured
    object.manufactured&.strftime "%Y/%m"
  end

  def car_status
    return if object.car_statuses.last.sales_status == 'on_sale'

    object.car_statuses.last.sales_status
  end

  def source_code
    case source
    when 'autodraft'
      :AD
    when 'business_lease'
      :BL
    else
      :unknown
    end
  end

  def source_badge
    time_diff = (Time.zone.now - object.created_at) / 60 / 60
    klass = time_diff <= 24 ? :green : (time_diff > 24 && time_diff <= 48 ? 'pale-green' : :none)
    h.content_tag :span, source_code, class: "status_tag #{klass}"
  end
end
