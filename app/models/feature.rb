class Feature < ApplicationRecord
  enum company: { autodraft: 1, business_lease: 2 }

  has_many :car_features
  has_many :cars, through: :car_features
  belongs_to :unified_feature

  validates_presence_of :company
  validates :title, presence: true, uniqueness: true

  scope :alphabetically, -> { order(:title) }
  scope :valuable, -> { where(valuable: true) }
end
