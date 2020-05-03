class Car < ApplicationRecord
  enum transmission: { unknown: 0, automatic: 1, manual: 2 }
  enum fuel: { other: 0, diesel: 1, petrol: 2, hybrid: 3 }

  has_many :crawls, dependent: :delete_all
  has_many :car_features, dependent: :delete_all
  has_many :features, through: :car_features
  has_many :car_statuses, dependent: :delete_all
  has_one :car_status

  validates_uniqueness_of :vin
end
