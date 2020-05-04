class CarPrice < ApplicationRecord
  belongs_to :car, touch: :updated_at

  scope :unique, -> { where('car_prices.id IN (SELECT MAX(car_prices.id) from car_prices GROUP BY car_id)') }
end
