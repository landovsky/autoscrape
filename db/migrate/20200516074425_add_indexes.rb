class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :car_prices, :price
    add_index :car_statuses, :sales_status
    add_index :crawls, :format
    add_index :crawls, :parsed_at
  end
end
