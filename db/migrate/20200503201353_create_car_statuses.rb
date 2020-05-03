class CreateCarStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :car_statuses do |t|
      t.references :car, foreign_key: true
      t.integer :sales_status, default: 1

      t.timestamps
    end
  end
end
