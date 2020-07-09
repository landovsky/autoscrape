class CarPrice < ApplicationRecord
  belongs_to :car, touch: :updated_at

  after_save :update_car_rating
  after_destroy :update_car_rating

  scope :last_change, -> { where('car_prices.id IN (SELECT MAX(car_prices.id) from car_prices GROUP BY car_id)')
                           .order('car_prices.created_at DESC') }
  scope :changed, -> { where('car_prices.car_id in (SELECT car_prices.car_id FROM car_prices GROUP BY car_prices.car_id HAVING COUNT(car_prices.car_id) > 1)')
                       .where('car_prices.id in (select max(car_prices.id) from car_prices group by car_prices.car_id)')
                       .order(:car_id, created_at: :desc) }

  def update_car_rating
    car.update_rating
  end

  def previous_price
    prices = CarPrice.where('car_id = ? AND id < ?', car_id, id).order(created_at: :desc).limit(1).first
    prices.presence
  end
end
