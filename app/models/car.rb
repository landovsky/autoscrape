class Car < ApplicationRecord
  enum transmission: { unknown: 0, automatic: 1, manual: 2 }
  enum fuel: { other: 0, diesel: 1, petrol: 2, hybrid: 3 }

  has_many :crawls, dependent: :delete_all
  has_many :car_features, dependent: :delete_all
  has_many :features, through: :car_features
  has_many :car_statuses, dependent: :delete_all
  has_one :car_status, -> { order(created_at: :desc) }
  has_many :car_prices, dependent: :delete_all
  has_one :car_price, -> { order(created_at: :desc) }

  delegate :sales_status, to: :car_status, allow_nil: true
  delegate :price, to: :car_price, allow_nil: true

  scope :without_crawl, -> { left_joins(:crawls).where(crawls: { car_id: nil })}
  scope :available, -> { joins(:car_statuses).merge(CarStatus.unique.available) }

  # validates_uniqueness_of :vin
end