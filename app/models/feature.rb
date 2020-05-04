class Feature < ApplicationRecord
  validates :title, uniqueness: true

  scope :alphabetically, -> { order(:title) }
end
