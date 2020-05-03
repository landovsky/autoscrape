class CarFeature < ApplicationRecord
  belongs_to :feature
  belongs_to :car

  validates :feature, uniqueness: { scope: :car }
end
