class AddAttributesToCars < ActiveRecord::Migration[5.2]
  def change
    change_table 'cars' do |t|
      t.integer :transmission
      t.integer :power_kw
      t.timestamp :manufactured
      t.integer :odometer
      t.integer :fuel
    end
  end
end
