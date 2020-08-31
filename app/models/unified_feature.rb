class UnifiedFeature < ApplicationRecord
  has_many :features, dependent: :nullify
end
