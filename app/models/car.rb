class Car < ApplicationRecord
  enum transmission: { unknown: 0, automatic: 1, manual: 2 }
  enum fuel: { other: 0, diesel: 1, petrol: 2, hybrid: 3, cng_petrol: 4, lpg_petrol: 5 }
  enum source: { autodraft: 1, sauto: 2, business_lease: 3 }

  has_many :crawls, dependent: :delete_all
  has_many :car_features, dependent: :delete_all
  has_many :features, through: :car_features
  has_many :car_statuses, dependent: :delete_all
  has_one :car_status, -> { order(created_at: :desc) }
  has_many :car_prices, dependent: :delete_all
  has_one :car_price, -> { order(created_at: :desc) }
  has_many :unified_features, through: :features

  delegate :sales_status, to: :car_status, allow_nil: true
  delegate :price, to: :car_price, allow_nil: true

  scope :with_price, -> { select('cars.*, car_prices.price')
                          .left_joins(:car_prices).merge(CarPrice.last_change).where('car_prices.price < 500000') }
  scope :price_changed, -> { unscoped.left_joins(:car_prices).merge(CarPrice.changed) }
  scope :with_status, -> { select('cars.*, car_statuses.sales_status').left_joins(:car_statuses).merge(CarStatus.last_change) }
  scope :without_crawl, -> { left_joins(:crawls).where(crawls: { car_id: nil })}
  scope :available, -> { joins(:car_statuses).merge(CarStatus.last_change.available) }
  scope :sold, -> { joins(:car_statuses).merge(CarStatus.last_change.sold) }
  scope :expired  , -> { joins(:car_statuses).merge(CarStatus.last_change.expired ) }
  scope :deposit, -> { joins(:car_statuses).merge(CarStatus.last_change.deposit) }
  scope :crawled_hours_ago, -> (hours) { where('last_seen IS NULL or last_seen < ?', hours.hours.ago) }

  validates_presence_of :url

  def age_months
    (Time.zone.now.year * 12 + Time.zone.now.month) - (manufactured.year * 12 + manufactured.month)
  end

  def self.update_rating
    Car.available.where.not(manufactured: nil).each(&:update_rating)
  end

  def update_rating
    return unless manufactured.present?
    update rating: car_prices.last.price / (500 - (odometer / 1000 + age_months))
  end

  def update_price(new_price)
    return unless price.present?
    return if price == new_price
    raise ArgumentError unless price.is_a? Integer

    car_prices << CarPrice.new(price: new_price)
  end
end
