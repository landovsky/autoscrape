class CarStatus < ApplicationRecord
  enum sales_status: { on_sale: 1, deposit: 2, sold: 3 }

  belongs_to :car, touch: :updated_at

  scope :last_change, -> { where('car_statuses.id IN (SELECT MAX(car_statuses.id) from car_statuses GROUP BY car_id)')
                           .order('car_statuses.created_at DESC') }
  scope :available, -> { where(sales_status: [1, 2]) }
end
