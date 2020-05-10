class CarPrice < ApplicationRecord
  belongs_to :car, touch: :updated_at

  scope :last_change, -> { where('car_prices.id IN (SELECT MAX(car_prices.id) from car_prices GROUP BY car_id)') }
  scope :changed, -> { where('car_prices.car_id in (SELECT car_prices.car_id FROM car_prices GROUP BY car_prices.car_id HAVING COUNT(car_prices.car_id) > 1)')
                       .where('car_prices.id in (select max(car_prices.id) from car_prices group by car_prices.car_id)')
                       .order(:car_id, created_at: :desc) }
end
