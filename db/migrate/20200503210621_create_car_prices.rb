class CreateCarPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :car_prices do |t|
      t.references :car, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
