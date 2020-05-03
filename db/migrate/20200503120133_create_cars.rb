class CreateCars < ActiveRecord::Migration[5.2]
  def change
    create_table :cars do |t|
      t.timestamp :last_seen
      t.string :title
      t.string :vin
      t.string :url

      t.timestamps
    end
  end
end
