class Feature < ApplicationRecord
  validates :title, uniqueness: true
end
