class Feature < ApplicationRecord
  has_many :car_features
  has_many :cars, through: :car_features

  validates :title, uniqueness: true

  scope :alphabetically, -> { order(:title) }
  scope :valuable, -> { where(valuable: true) }
end
