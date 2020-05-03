class CarStatus < ApplicationRecord
  enum sales_status: { on_sale: 1, deposit: 2, sold: 3 }

  belongs_to :car
end
