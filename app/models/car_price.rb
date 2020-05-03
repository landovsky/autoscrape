class CarPrice < ApplicationRecord
  belongs_to :car, touch: :updated_at
end
